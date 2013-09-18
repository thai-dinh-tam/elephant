class FailuresController < ApplicationController
    before_filter :signed_in_user, only: [:index, :create, :show]
    before_filter :signed_in_admin, only: [:new, :update, :edit, :destroy]

    def index
        @job = Job.find_by_id(params[:job_id])
        not_found unless @job.company == current_user.company

        @rate = params[:rate] == "true"
    end

    def show
        if request.format != "html"
            @job = Job.find_by_id(params[:id])
            not_found unless @job.company == current_user.company

            jobs_query = Job.where("jobs.job_template_id = :job_template_id AND jobs.failures_count > 1", job_template_id: @job.job_template_id).select("jobs.id").to_sql
            failure_groups = Failure.includes(:failure_master_template).where("failures.job_id IN (#{jobs_query})").order("COUNT(failures.failure_master_template_id) DESC").select("failures.*, DISTINCT failures.failure_master_template_id").group("failures.failure_master_template_id").count()

            @failures = []

            failure_groups.each do |fg|
                master = Failure.find_by_id(fg[0])
                failure_list = Failure.where("failure_master_template_id = ?", master.id).limit(3)
                failure_list.select! { |f| f.job_id.present? && f.job_id != @job.id }
                if failure_list.any?
                    @failures << [master, failure_list]
                end
            end
        end

        respond_to do |format|
            format.html {
                @failure = Failure.find_by_id(params[:id])
                not_found unless @failure.company == current_user.company

                jobs_query = Failure.select("failures.job_id").where("failures.failure_master_template_id = ?", @failure.id).to_sql
                @jobs = Job.includes(dynamic_fields: :dynamic_field_template).includes(:field, :well, :job_processes, :documents, :district, :client, :job_template => {:primary_tools => :tool}).where("jobs.id IN (#{jobs_query})").order("jobs.created_at ASC").paginate(page: params[:page], limit: 20)
            }
            format.js {
                render 'failures/show'
            }
            format.xml {
                render xml: @failures,
                       except: [:created_at, :updated_at, :company_id, :job_template_id, :product_line_id, :template]
            }
        end

    end

    def new
        @failure = Failure.new
        @failure.product_line = ProductLine.find_by_id(params[:product_line])
    end

    def create
        if signed_in_admin?
            failure_master_template_id = params[:failure][:failure_master_template_id]
            params[:failure].delete(:failure_master_template_id)

            product_line_id = params[:failure][:product_line_id]
            params[:failure].delete(:product_line_id)

            job_template_id = params[:failure][:job_template_id]
            params[:failure].delete(:job_template_id)

            @failure = Failure.new(params[:failure])
            @failure.company = current_user.company

            if !product_line_id.blank?
                @failure.product_line = ProductLine.find_by_id(product_line_id)
                not_found unless @failure.product_line.company == current_user.company
                @failure.template = true
            elsif !failure_master_template_id.blank?
                @failure.failure_master_template = Failure.find_by_id(failure_master_template_id)
                not_found unless @failure.failure_master_template.company == current_user.company

                @failure.job_template = JobTemplate.find_by_id(job_template_id)
                not_found unless @failure.job_template.company == current_user.company
            end

            @failure.save
        elsif params[:failures][:job_id]

            @rating = params[:performance_rating]

            @job = Job.find_by_id(params[:failures][:job_id])
            not_found unless @job.present?
            not_found unless @job.company == current_user.company

            Failure.transaction do
                failures_array = @job.failures.to_a
                failures_array.each do |failure|
                    if params[:failures][failure.id.to_s] != "1"
                        Failure.find_by_id(failure.id)
                        if failure.company == current_user.company
                            failure.destroy
                            Issue.remove(failure)
                        end
                    end
                end
                @job.job_template.failures.each do |failure|
                    if params[:failures][failure.id.to_s] == "1"
                        if failures_array.find { |f| f.failure_master_template_id = failure.id } == nil
                            job_failure = Failure.new
                            job_failure.company = current_user.company
                            job_failure.failure_master_template = failure.failure_master_template
                            job_failure.reference = params[failure.id.to_s + "_reference"]
                            job_failure.job = @job
                            job_failure.save

                            Issue.add(job_failure, current_user.company, @job)

                            Activity.add(self.current_user, Activity::JOB_FAILURE, job_failure, nil, @job)
                        end
                    end
                end
            end

            if !@rating.blank?
                @job.update_attribute(:rating, @rating.to_i)
                Activity.add(self.current_user, Activity::JOB_RATING, @job, @rating.to_i, @job)
            end

            @job = Job.find_by_id(@job.id)

            render 'failures/update_list'
            return
        end
    end

    def edit
        @failure = Failure.find_by_id(params[:id])
        not_found unless  @failure.company == current_user.company
    end

    def update
        @failure = Failure.find_by_id(params[:id])
        not_found unless  @failure.company == current_user.company

        @master_failure = @failure.failure_master_template

        @master_failure.text = params[:failure][:text]
        @master_failure.save

    end

    def destroy
        @failure = Failure.find_by_id(params[:id])
        not_found unless  @failure.company == current_user.company
        @failure.destroy
    end

end

class JobProcessMailer < ActionMailer::Base
    default from: "system@go-elephant.com"

    def pre_job_data_complete(user, job)
        @user = user
        @job = job
        mail(:to => "ryan.dawson@go-elephant.com, mdawson@dawsonparrish.com, schuldes2004@gmail.com",
             :subject => "Pre-Job complete: #{@job.field.name} | #{@job.well.name} | #{@job.job_template.product_line.name}")
    end

    def post_job_data_complete(user, job)
        @user = user
        @job = job
        mail(:to => "ryan.dawson@go-elephant.com, mdawson@dawsonparrish.com, schuldes2004@gmail.com",
             :subject => "Post-Job complete: #{@job.field.name} | #{@job.well.name} | #{@job.job_template.product_line.name}")
    end

    def ship_to_field(user, job)
        @user = user
        @job = job
        mail(:to => "ryan.dawson@go-elephant.com, mdawson@dawsonparrish.com, schuldes2004@gmail.com",
             :subject => "Job Shipping to Field: #{@job.field.name} | #{@job.well.name} | #{@job.job_template.product_line.name}")
    end

    def job_complete(user, job)
        @user = user
        @job = job
        mail(:to => "ryan.dawson@go-elephant.com, mdawson@dawsonparrish.com, schuldes2004@gmail.com",
             :subject => "Job complete: #{@job.field.name} | #{@job.well.name} | #{@job.job_template.product_line.name}")
    end
end

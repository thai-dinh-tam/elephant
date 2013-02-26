class JobNotesController < ApplicationController
    before_filter :signed_in_user, only: [:new, :create, :destroy]


    def new
        @job_note = JobNote.new
    end

    def create
        job_id = params[:job_note][:job_id]
        params[:job_note].delete(:job_id)

        assign_to_id = params[:job_note][:assign_to_id]
        params[:job_note].delete(:assign_to_id)

        @job_note = JobNote.new(params[:job_note])
        @job_note.company = current_user.company
        @job_note.user = current_user
        @job_note.job = Job.find_by_id(job_id)
        @job_note.assign_to = User.find_by_id(assign_to_id)

        if @job_note.save

            Activity.add(self.current_user, Activity::JOB_NOTE_ADDED, @job_note, nil, @job_note.job)

            if @job_note.assign_to.present?
                alert = Alert.add(@job_note.assign_to, Alert::TASK_ASSIGNED, @job_note, self.current_user, @job_note.job)
                @job_note.assign_to.delay.send_alert_email(alert)
            end
        end
    end

    def destroy
        @job_note = JobNote.find(params[:id])
        not_found unless @job_note.company == current_user.company

        #Activity.add(self.current_user, Activity::CLIENT_DESTROYED, @client, @client.name)
        @job_note.destroy
    end

end

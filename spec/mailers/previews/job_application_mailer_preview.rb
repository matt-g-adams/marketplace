# Preview all emails at http://localhost:3000/rails/mailers/job_application_mailer
class JobApplicationMailerPreview < ActionMailer::Preview
    def job_application_email
        JobApplicationMailer.with(job_application: JobApplication.first).job_application_email
    end
end

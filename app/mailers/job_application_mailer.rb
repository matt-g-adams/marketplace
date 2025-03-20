class JobApplicationMailer < ApplicationMailer
  def job_application_email
    @job_application = params[:job_application]
    client = @job_application.opportunity.client
    mail(to: email_address_with_name(client.email, client.name), subject: "New Job Application")
  end
end

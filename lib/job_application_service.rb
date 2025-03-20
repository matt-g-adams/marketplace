class JobApplicationService
  def self.apply(opportunity_id, job_application_params)
    opportunity = Opportunity.find(opportunity_id)
    return { error: :not_found } unless opportunity
    job_application = JobApplication.new(job_application_params)

    if job_application.save
      JobApplicationMailer.with(job_application: job_application).job_application_email.deliver_later
      { job_application: job_application }
    else
      { errors: job_application.errors }
    end
  end
end

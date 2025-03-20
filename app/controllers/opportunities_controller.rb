class OpportunitiesController < ApplicationController
  # GET /opportunities
  def index
    opportunities = OpportunityService.search(params)

    render json: opportunities
  end

  # POST /opportunities
  def create
    opportunity = Opportunity.new(opportunity_params)

    if opportunity.save
      render json: opportunity, status: :created
    else
      render json: opportunity.errors, status: :unprocessable_content
    end
  end

  # POST /opportunities/:id/apply
  def apply
    result = JobApplicationService.apply(params[:id], job_application_params)
    if result[:error]
      render status: result[:error]
    elsif result[:errors]
      render json: result[:errors], status: :unprocessable_content
    else
      render json: result[:job_application], status: :created
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def opportunity_params
    params.expect(opportunity: [:title, :description, :salary, :client_id])
  end

  def job_application_params
    params.expect(job_application: [:job_seeker_id, :opportunity_id])
  end
end

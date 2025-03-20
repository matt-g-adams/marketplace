module OpportunityService
  def self.search(params)
    key = params.values_at(:limit, :after_id, :client_id, :client_name, :client_email, :min_salary, :title, :description)

    Rails.cache.fetch(key, expires_in: 1.minute) do
      opportunities = Opportunity.includes(:client)
      opportunities = opportunities.limit(params[:limit]) if params[:limit]
      opportunities = opportunities.where("id > ?", params[:after_id]) if params[:after_id]
      opportunities = opportunities.where(client_id: params[:client_id]) if params[:client_id]
      opportunities = opportunities.where(client: { name: params[:client_name] }) if params[:client_name]
      opportunities = opportunities.where(client: { email: params[:client_email] }) if params[:client_email]
      opportunities = opportunities.where("salary >= ?", params[:min_salary]) if params[:min_salary]
      opportunities = opportunities.where("title LIKE ?", "%#{params[:title]}%") if params[:title]
      opportunities = opportunities.where("description LIKE ?", "%#{params[:description]}%") if params[:description]
      opportunities.order(:id)
    end
  end
end

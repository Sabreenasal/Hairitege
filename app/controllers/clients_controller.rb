class ClientsController < ApplicationController
  before_action :authenticate_user!

  def mane_vault
    @client = User.find(params[:client_id])
  
    @recommendations = @client.recommendations_as_client.includes(:product)
  end
end

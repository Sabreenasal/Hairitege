class ClientsController < ApplicationController
  before_action :authenticate_user!

  def mane_vault
    @client = User.find(params[:client_id])
    @recommendations = @client.recommendations.includes(:product)
  end
end

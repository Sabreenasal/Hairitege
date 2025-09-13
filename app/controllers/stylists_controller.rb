class StylistsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @stylist = current_user
    @clients = @stylist.clients.reload
    @new_client = User.new
  end

  def create_client
  @new_client = User.new(client_params)
  @new_client.role = "client"  # ensure role is set

  if @new_client.save
    # Step 1: make sure there’s at least one product
    default_product = Product.first
    unless default_product
      flash[:alert] = "You must create a product before adding clients."
      redirect_to stylist_dashboard_path and return
    end

    # Step 2: create recommendation linking stylist and client
    Recommendation.create!(
      stylist_id: current_user.id,
      client_id: @new_client.id,
      product_id: default_product.id
    )

    # Step 3: redirect back to dashboard
    redirect_to stylist_dashboard_path, notice: "Client added successfully."
  else
    # If save failed, re-render dashboard with errors
    Rails.logger.debug @new_client.errors.full_messages
    @stylist = current_user
    @clients = @stylist.clients.reload
    flash.now[:alert] = @new_client.errors.full_messages.join(", ")
    render :dashboard
  end

  def remove_client
    client = User.find(params[:id])
    recommendation = Recommendation.find_by(stylist_id: current_user.id, client_id: client.id)

    if recommendation
      recommendation.destroy
      flash[:notice] = "#{client.name} has been removed from your clients."
    else
      flash[:alert] = "Client not found."
    end

    redirect_to stylist_dashboard_path
  end
end


  private

  def client_params
    params.require(:user).permit(:name, :email, :password)
  end
end

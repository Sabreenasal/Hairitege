class RecommendationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommendation, only: [:edit, :update]

  def edit
   
  end

  def update
    if @recommendation.update(recommendation_params)
      redirect_to mane_vault_client_path(@recommendation.client_id), notice: "Notes updated!"
    else
      flash.now[:alert] = @recommendation.errors.full_messages.join(", ")
      render :edit
    end
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:notes)
  end
end

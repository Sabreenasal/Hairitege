class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Recommendations
  has_many :recommendations_as_stylist, class_name: "Recommendation", foreign_key: "stylist_id", dependent: :destroy
  has_many :recommendations_as_client, class_name: "Recommendation", foreign_key: "client_id", dependent: :destroy

  # Fetch clients via recommendations (1 stylist → many clients)
  def clients
    User.joins(:recommendations_as_client)
        .where(recommendations: { stylist_id: id })
        .distinct
  end

  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= "stylist"
  end
end

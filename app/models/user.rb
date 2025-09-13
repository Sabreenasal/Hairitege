class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role can be 'stylist' or 'client'
  # You may want to validate presence of role:
  validates :role, presence: true, inclusion: { in: %w[stylist client] }

  # Associations
  # A stylist has many recommendations for their clients
  has_many :given_recommendations, class_name: "Recommendation", foreign_key: "stylist_id", dependent: :destroy

  # A client has many recommendations
  has_many :recommendations, foreign_key: "client_id", dependent: :destroy

  # Helper: stylist has many clients through recommendations
  has_many :clients, through: :given_recommendations, source: :client
end

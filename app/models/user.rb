class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :plan
  # Remove the stripe_card_token accessor since it's handled by the controller
  # attr_accessor :stripe_card_token

  # If needed, you can add any validation or custom methods specific to your user model
  # Example: validate :some_custom_validation

  # Stripe customer token and subscription ID attributes
  attr_accessor :stripe_card_token
  attr_accessor :stripe_customer_token
  attr_accessor :stripe_subscription_id
end

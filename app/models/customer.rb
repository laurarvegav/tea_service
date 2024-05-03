class Customer < ApplicationRecord

  validates :f_name, presence: true
  validates :l_name, presence: true
  validates :email, presence: true
  validates :address, presence: true

  has_secure_password

  has_many :customer_subscriptions
  has_many :subscriptions, through: :customer_subscriptions
end

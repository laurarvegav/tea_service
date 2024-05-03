class Subscription < ApplicationRecord

  validates :title, presence: true
  validates :price, presence: true
  validates :status, presence: true
  validates :frequency, presence: true

  has_many :customer_subscriptions
  has_many :customers, through: :customer_subscriptions
end

class CustomerSubscription < ApplicationRecord
  belongs_to :customer
  belongs_to :subscription

  enum status: ["active", "cancelled"]
  validates :customer_id, uniqueness: { scope: :subscription_id }
end

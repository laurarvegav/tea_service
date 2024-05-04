require 'rails_helper'

RSpec.describe CustomerSubscription, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :subscription }
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["active", "cancelled"])
    end
  end

  describe "validations" do
    it "validates uniqueness of customer_id and subscription_id pair" do
      customer = Customer.create(f_name: "John", l_name: "Doe", email: "john@example.com", address: "123 Main St", password_digest: "password")
      subscription = Subscription.create(title: "Premium", price: 9.99, frequency: "monthly")

      CustomerSubscription.create(customer: customer, subscription: subscription)

      # Attempt to create a duplicate customer_subscription record
      duplicate_subscription = CustomerSubscription.new(customer: customer, subscription: subscription)
      
      expect(duplicate_subscription).not_to be_valid
      expect(duplicate_subscription.errors[:customer_id]).to include("has already been taken")
    end
  end
end
require "rails_helper"

RSpec.describe "Subscribe a customer to a tea subscription" do
  before(:each) do
    @user_data = {
      email: "test@woohoo.com",
      tea_service: "atlas"
    }

    @bad_user_data_1 = {
      email: "test@email.com",
      password: "abc123",
      tea_service: "educate"
    }

    @bad_user_data_2 = {
      email: "unexistent@email.com",
      password: "abc123",
      tea_service: ""
    }

    @bad_user_data_3 = {
      email: "test@woohoo.com",
      password: "abc123",
      tea_service: "atlas"
    }

    @user_ok_1 = Customer.create!({email: "test@woohoo.com", f_name: "Charlie", l_name: "Za", address: "123 St, Fun CO, 80021", password: "123test"})

    @subscription_ok_1 = Subscription.create!({title: "atlas", price: 12.2, frequency: "bi-weekly"})
  end
  
  describe '#happy path' do
  it "can subscribe a customer to a new service" do
    post "/api/v0/customers/#{@user_ok_1.id}/subscriptions", params: @user_data, as: :json

    response_data = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(response_data[:message]).to eq("Subscription successfully added to Customer")
    end
  end

  describe '#sad path' do
    it "sends an error when a client tries to add a subscription that they already have" do
      CustomerSubscription.create!({subscription: @subscription_ok_1, customer: @user_ok_1})
      
      post "/api/v0/customers/#{@user_ok_1.id}/subscriptions", params: @bad_user_data_3, as: :json

      expect(response).not_to be_successful

      error_response = JSON.parse(response.body, symbolize_names: true)

      expect(error_response).to have_key(:errors)
      expect(error_response[:errors]).to be_a(Array)

      expect(error_response[:errors].first).to have_key(:detail)
      expect(error_response[:errors].first[:detail]).to eq("Validation failed: Customer has already been taken")
    end

    it "errors with an invalid" do 
      post "/api/v0/customers/#{@user_ok_1.id}/subscriptions", params: @bad_user_data_1, as: :json

      
      expect(response).to_not be_successful

      expect(response.status).to eq(404)
  
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Subscription must exist")
    end
  end
end
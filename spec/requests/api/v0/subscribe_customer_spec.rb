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
      email: "test@email.com",
      password: "abc123",
      tea_service: ""
    }

    @bad_user_data_3 = {
      email: "test@woohoo.com",
      password: "abc123",
      tea_service: "atlas"
    }

    @user_ok_1 = User.new({email: "test@woohoo.com", f_name:, l_name:, address: })
  end
  
  describe '#happy path' do
  it "can subscribe a customer to a new service" do
    post "/api/v0/customers/#{@user_ok_1.id}/subscriptions", params: @user_data, as: :json
    
    new_cust_sub = CustomerSubscription.last
      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(new_cust_sub.status).to eq(0)

      expect(response.status).to eq(201)
      check_hash_structure(response_data, :data, Hash)
      check_hash_structure(response_data[:data], :type, String)
      check_hash_structure(response_data[:data], :id, String)
      check_hash_structure(response_data[:data], :attributes, Hash)
      # check_hash_structure(response_data[:data][:attributes], :email, String)
      # check_hash_structure(response_data[:data][:attributes], :api_key, String)
    end
  end

#   describe '#sad path' do
#     it "will return the correct error message and be unsuccessful if the passwords don't match", :vcr do
#       post "/api/v0/users", params:  @bad_user_data_1, as: :json
      
#       expect(response).not_to be_successful

#       error_response = JSON.parse(response.body, symbolize_names: true)

#       check_hash_structure(error_response, :errors, Array)

#       errors = error_response[:errors].first

#       check_hash_structure(errors, :detail, String)
#       expect(errors[:detail]).to eq("Validation failed: Password confirmation doesn't match Password")
#     end

#     it "will return the correct error message and be unsuccessful if any attribute is left blank", :vcr do
#       post "/api/v0/users", params: @bad_user_data_2, as: :json 

#       expect(response).not_to be_successful

#       error_response = JSON.parse(response.body, symbolize_names: true)

#       check_hash_structure(error_response, :errors, Array)

#       errors = error_response[:errors].first

#       check_hash_structure(errors, :detail, String)
#       expect(errors[:detail]).to eq("Validation failed: Password confirmation doesn't match Password")
#     end

#     it "will return the correct error message and be unsuccessful if the email is already associated to a user", :vcr do
#       post "/api/v0/users", params: @user_data, as: :json

#       post "/api/v0/users", params: @bad_user_data_3, as: :json

#       expect(response).not_to be_successful

#       error_response = JSON.parse(response.body, symbolize_names: true)

#       check_hash_structure(error_response, :errors, Array)

#       errors = error_response[:errors].first

#       check_hash_structure(errors, :detail, String)
#       expect(errors[:detail]).to eq("Validation failed: Email has already been taken, Password confirmation doesn't match Password")
#     end
#   end
end
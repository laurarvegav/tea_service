require "rails_helper"

RSpec.describe "Customer subscriptions" do
  describe "GET all subscriptions" do
    before(:each) do
      @good_data = {
        email: "test@woohoo.com",
        tea_service: "sturni"
      }
      
      @bad_data_1 = {
        email: "unexistent@email.com",
        tea_service: "sturni"
      }
  
      @bad_data_3 = {
        email: "test@woohoo.com",
        tea_service: "north"
      }
  
      @user_ok_1 = Customer.create!({email: "test@woohoo.com", f_name: "Charlie", l_name: "Za", address: "123 St, Fun CO, 80021", password: "123test"})
  
      @subscription_ok_1 = Subscription.create!({title: "atlas", price: 12.2, frequency: "bi-weekly"})

      @subscription_ok_3 = Subscription.create!({title: "sturni", price: 8.6, frequency: "yearly"})

      @subscription_ok_2 = Subscription.create!({title: "south", price: 35.7, frequency: "monthly"})

      @cli_sub_1 = CustomerSubscription.create!({subscription: @subscription_ok_1, customer: @user_ok_1})

      @cli_sub_2 = CustomerSubscription.create!({subscription: @subscription_ok_2, customer: @user_ok_1})

      @cli_sub_3 = CustomerSubscription.create!({subscription: @subscription_ok_3, customer: @user_ok_1})

      @params = JSON.generate(customer_subscription: @good_data)
    end

    describe "Happy path" do
      it "retrieves client's active and inactive tea subscritions" do
        delete "/api/v0/customers/#{@user_ok_1.id}/subscriptions/#{@subscription_ok_3.id}", params: @params

        get "/api/v0/customers/#{@user_ok_1.id}/subscriptions"
      
        titles = []
        expect(response).to be_successful
        response_data = JSON.parse(response.body, symbolize_names: true)

        check_hash_structure(response_data, :subscriptions, Array)

        response_data[:subscriptions].each do |subscription|
          check_hash_structure(subscription, :data, Hash)
          check_hash_structure(subscription[:data], :attributes, Hash)
          check_hash_structure(subscription[:data][:attributes], :title, String)
          titles << subscription[:data][:attributes][:title]
          check_hash_structure(subscription[:data][:attributes], :price, Float)
          check_hash_structure(subscription[:data][:attributes], :frequency, String)
        end

        expect(titles.include?(@subscription_ok_3.title)).to eq(true)
      end
    end
    
    describe "Sad Path" do 
      it "will return the correct error message when given invalid customer id" do 
        get "/api/v0/customers/12345/subscriptions"

        expect(response).not_to be_successful
  
        response_data = JSON.parse(response.body, symbolize_names: true)
  
        check_hash_structure(response_data, :errors, Array)
        expect(response_data[:errors].first).to be_a(Hash)
        check_hash_structure(response_data[:errors].first, :detail, String)
        expect(response_data[:errors].first[:detail]).to eq("Couldn't find Customer with 'id'=12345")
      end
    end
  end
end
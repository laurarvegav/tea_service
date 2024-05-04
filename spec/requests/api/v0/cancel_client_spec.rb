require "rails_helper"

RSpec.describe "Customer" do
  describe "Cancels a subscription" do
    before(:each) do  
      @good_data = {
        email: "test@woohoo.com",
        tea_service: "atlas"
      }
      
      @bad_data = {
        email: "test@woohoo.com",
        tea_service: "south"
      }

      @user_ok_1 = Customer.create!({email: "test@woohoo.com", f_name: "Charlie", l_name: "Za", address: "123 St, Fun CO, 80021", password: "123test"})
  
      @subscription_ok_1 = Subscription.create!({title: "atlas", price: 12.2, frequency: "bi-weekly"})

      @subscription_ok_2 = Subscription.create!({title: "south", price: 35.7, frequency: "monthly"})

      @cli_sub_1 = CustomerSubscription.create!({subscription: @subscription_ok_1, customer: @user_ok_1})

      @params_ok = JSON.generate(customer_subscription: @good_data)
      @params_bad = JSON.generate(customer_subscription: @bad_data)
    end

    describe "Happy path" do
      it "cancels given tea subscrition" do
        delete "/api/v0/customers/#{@user_ok_1.id}/subscriptions/#{@subscription_ok_1.id}", params: @params_ok

        expect(response).to be_successful
        expect(response.status).to eq(200)
        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:message]).to eq("Customer subscription successfully cancelled")
      end
    end

    describe "Sad Path" do 
      it "errors if association does not exist" do 
        delete "/api/v0/customers/#{@user_ok_1.id}/subscriptions/#{@subscription_ok_2.id}", params: @params_bad
        
        expect(response).not_to be_successful
        expect(response.status).to eq(404)

        error_response = JSON.parse(response.body, symbolize_names: true)

        expect(error_response).to have_key(:message)
        expect(error_response[:message]).to eq("Customer subscription does not exist")
      end
    end
  end
end
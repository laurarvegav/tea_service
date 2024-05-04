class Api::V0::SubscriptionsController < ApplicationController

  def create
    CustomerSubscription.create!(customer_subscription_params)

    render json: {message: "Subscription successfully added to Customer"}
  end

  def index
    customer_subscriptions = Customer.find(params[:customer_id]).customer_subscriptions

    subscriptions = []
    customer_subscriptions.each do |customer_subscription|
      subscription = Subscription.find(customer_subscription.subscription_id)


      subscriptions << SubscriptionSerializer.new(subscription)
    end
    render json: 
    { subscriptions: subscriptions }
  end

  def destroy
    customer_subscription = CustomerSubscription.find_by(customer_subscription_data)

    if customer_subscription 
      customer_subscription.status = 1
      render json: {message: "Customer subscription successfully cancelled"}, status: 200
    else 
      render json: {message: "Customer subscription does not exist"}, status: 404
    end 
  end

  private
  def customer_subscription_params
    {
      subscription: Subscription.find_by(title: params[:tea_service]),
      customer: Customer.find(params[:customer_id])
    }
  end

  def customer_subscription_data
    {
      subscription: Subscription.find(params[:id]),
      customer: Customer.find(params[:customer_id])
    }
  end
end
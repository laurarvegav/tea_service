class Api::V0::SubscriptionsController < ApplicationController

  def create
    subscription = Subscription.find_by(title: params[:tea_service])
    customer = Customer.find(params[:customer_id])

    CustomerSubscription.create!({subscription: subscription, customer: customer})

    render json: {message: "Subscription successfully added to Customer"}
  end
end
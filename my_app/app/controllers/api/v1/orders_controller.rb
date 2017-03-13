class Api::V1::OrdersController < ApplicationController
  def create
    order = Order.new(safe_params[:order])
    order.user_id = current_user.id
    if order.save
      head 201
    else
      head 422
    end
  end

  def index
    orders = order_query.map do |order|
      { user: { email: order.user.email }, restaurant: order.restaurant }
    end

    render json: { results: orders }
  end

  private

  def order_query
    current_user_groups_ids = current_user.groups.map(&:id)
    Order
      .where(group_id: current_user_groups_ids)
      .or(Order.where(user_id: current_user.id))
      .order(created_at: :desc)
  end

  def safe_params
    params.permit!
  end
end

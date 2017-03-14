class Api::V1::OrdersController < ApplicationController
  def create
    invited_users_emails = safe_params[:order].delete('invited_users_emails')
    order = Order.new(safe_params[:order])
    if invited_users_emails.present?
      order.users = User.where(email: invited_users_emails)
    end
    order.user_id = current_user.id
    if order.save
      head 201
    else
      head 422
    end
  end

  def index
    orders = order_query.map do |order|
      users = order.users.order(:email).to_a
      users += order.group.users if order.group
      users << order.user
      users = users.map do |user|
        { email: user.email }
      end.uniq
      {
        invited_users: users,
        founder: { email: order.user.email },
        restaurant: order.restaurant
      }
    end

    render json: { results: orders }
  end

  private

  def order_query
    current_user_groups_ids = current_user.groups.map(&:id)
    Order
      .where(group_id: current_user_groups_ids)
      .or(Order.where(user_id: current_user.id))
      .or(Order.where(id: current_user.orders.pluck(:id)))
      .order(created_at: :desc)
  end

  def safe_params
    params.permit!
  end
end

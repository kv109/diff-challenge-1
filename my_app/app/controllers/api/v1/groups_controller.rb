class Api::V1::GroupsController < ApplicationController
  def create
    group_params = safe_params[:group]
    emails = group_params.fetch('emails')
    users = User.where(email: emails).to_a
    users << current_user
    group = Group.new(users: users)

    if group.save
      head 201
    else
      head 422
    end
  end

  def index
    groups = Group.order(created_at: :desc).map do |group|
      users = group.users.order(:email).map do |user|
        { email: user.email, id: user.id }
      end

      { id: group.id, name: group.name, users: users }
    end

    render json: { results: groups }
  end

  private

  def safe_params
    params.permit!
  end
end

class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:sign_in, :sign_up]

  def sign_in
    user = User.find_by(email: params[:email], password: params[:password])
    if user
      render json: { access_token: user.access_token }
    else
      head 401
    end
  end

  def sign_up
    user = User.new(safe_params[:user])
    if user.save
      head 201
    else
      head 422
    end
  end

  def safe_params
    params.permit!
  end
end

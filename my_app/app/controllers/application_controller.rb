class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authenticate_user!
    head 401 unless current_user
  end

  def current_user
    @current_user ||=
      User.find_by(access_token: request.headers['X-Access-Token'])
  end
end

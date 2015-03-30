class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?
  # before_action :wait
  def wait
    sleep 0.5
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def signed_in?
    !current_user.nil?
  end
  def authenticate_user
    redirect_to root_path unless signed_in?
  end
end

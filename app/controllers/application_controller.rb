class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :wait
  def wait
    sleep 0.5
  end
end

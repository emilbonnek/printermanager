class SettingsController < ApplicationController
  def index
    cookies[:current_time] = params[:current_time]
    redirect_to root_path
  end
end

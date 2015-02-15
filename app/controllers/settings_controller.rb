class SettingsController < ApplicationController
  def index
    cookies[:current_time] = params[:current_time][:show]
    cookies[:something] = params[:something][:show]
    redirect_to root_path
  end
end

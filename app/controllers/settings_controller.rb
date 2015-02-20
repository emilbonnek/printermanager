class SettingsController < ApplicationController
  def update
    cookies[:current_time] = params[:current_time][:toggle]
    cookies[:something] = params[:something][:toggle]
    redirect_to root_path
  end
end

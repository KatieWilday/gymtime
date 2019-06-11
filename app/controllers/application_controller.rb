class ApplicationController < ActionController::Base

  def current_user
    if session[:client_id].present?
      client = Client.find_by(:id => session[:user_id])
    end
  end

  def require_login
    unless current_user
      redirect_to root_url
    end
  end
end

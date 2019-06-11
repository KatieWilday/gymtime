class SessionsController < ApplicationController

  def new
  end

  def create
    client = Client.find_by(:username => params[:username])
    if client && client.authenticate(params[:password_digest])
      session[:client_id] = client.id
      redirect_to client_path(client)
    else
      render :new
    end
  end

  def destroy
    if current_user
      session.delete :client_id
      redirect_to root_url
    end
  end

    private

  def auth
    request.env['omniauth.auth']
  end
end  

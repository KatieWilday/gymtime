class SessionsController < ApplicationController

  def new
  end

  def create
    if auth_hash = request.env["omniauth.auth"]
      binding.pry
      if client = Client.find_by(email: auth_hash["info"]["email"])
        session[:client_id] = client.id
        redirect_to client_path(client)
      else
        client = Client.new(email: auth_hash['info']['email'], password_digest: SecureRandom.hex, username: auth_hash['info']['username'])
        if client.save
          session[:client_id] = client.id
          redirect_to client_path(client)
        else
          raise client.errors.full_messages.inspect
        end
      end
    else
      client = Client.find_by(username: params[:username])
      if client && client.authenticate(params[:password])
        session[:client_id] = client.id
        redirect_to client_path(client)
      else
        flash.now[:error] = 'Invalid email/password combination'
        render :new
      end
    end
  end

  def destroy
    if current_client
      session.delete :client_id
      redirect_to root_url
    end
  end

   private
  def auth
     request.env['omniauth.auth']
  end

  def authenticate
    self.has_password?(password)
  end
end  

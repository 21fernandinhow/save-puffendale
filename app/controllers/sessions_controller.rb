class SessionsController < ApplicationController
  def new
    # apenas renderiza o form de login
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: "Bem-vindo de volta, #{user.name}!"
    else
      flash.now[:alert] = "Email ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Você saiu com sucesso."
  end
end
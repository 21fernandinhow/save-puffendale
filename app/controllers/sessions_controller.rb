class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]

  def new
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

  def root_redirect
    if logged_in?
      redirect_to home_path
    else
      redirect_to login_path
    end
  end

  private

  def redirect_if_logged_in
    redirect_to home_path if logged_in?
  end
end
class GameModesController < ApplicationController
    before_action :authenticate_user!
  
    def show
      @user = current_user
    end
  
    def update
      @user = current_user
  
      if @user.update(game_mode_params)
        redirect_to game_mode_path, notice: "Modo de jogo definido."
      else
        render :show, status: :unprocessable_entity
      end
    end
  
    private
  
    def game_mode_params
      params.require(:user).permit(:difficulty)
    end
  end
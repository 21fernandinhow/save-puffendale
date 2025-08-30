class VillageController < ApplicationController
  before_action :require_login

  def index
    @magic_points = current_user.magic_points
    @achievements = current_user.unlocked_achievements
  end
end
class VillageController < ApplicationController
  before_action :authenticate_user!

  def index
    @magic_points = current_user.magic_points
    @achievements = current_user.unlocked_achievements
  end
end
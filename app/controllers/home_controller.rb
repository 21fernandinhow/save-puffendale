class HomeController < ApplicationController
  before_action :require_login

  def index
    # @task_lists = current_user.tasklists.includes(:tasks)
  end
end
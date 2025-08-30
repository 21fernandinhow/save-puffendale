class HomeController < ApplicationController
  before_action :require_login

  def index
    @task_lists = current_user.task_lists.includes(:tasks)
    @new_task_list = TaskList.new
  end
end
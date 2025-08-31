class HomeController < ApplicationController
  def index
    if logged_in?
      @task_lists = current_user.task_lists.includes(:tasks)
      @new_task_list = TaskList.new
      render :dashboard # usa a view "dashboard.html.erb"
    else
      render :landing # usa a view "landing.html.erb"
    end
  end
end
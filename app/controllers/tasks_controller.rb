class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task_list
  before_action :set_task, only: %i[update destroy]

  # POST /task_lists/:task_list_id/tasks
  def create
    @task = @task_list.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_list_path(@task_list), notice: "Task criada com sucesso!" }
        format.json { render :show, status: :created, location: [@task_list, @task] }
      else
        format.html { render "task_lists/show", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_lists/:task_list_id/tasks/:id
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_list_path(@task_list), notice: "Task atualizada com sucesso!", status: :see_other }
        format.json { render :show, status: :ok, location: [@task_list, @task] }
      else
        format.html { render "task_lists/show", status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_lists/:task_list_id/tasks/:id
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to task_list_path(@task_list), notice: "Task removida com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_task
    @task = @task_list.tasks.find(params[:id])
  end

  def set_task_list
    @task_list = current_user.task_lists.find(params[:task_list_id])
  end

  def task_params
    params.require(:task).permit(:name, :completed)
  end
end
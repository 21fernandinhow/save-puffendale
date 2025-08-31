class TaskListsController < ApplicationController
  before_action :require_login
  before_action :set_task_list, only: %i[ show edit update destroy ]
  before_action :require_ownership, only: %i[show edit update destroy]

  # GET /task_lists or /task_lists.json
  def index
    @task_lists = current_user.task_lists.includes(:tasks)
  end

  # GET /task_lists/1 or /task_lists/1.json
  def show
    @tasks = @task_list.tasks
  end

  # GET /task_lists/new
  def new
    @task_list = TaskList.new
  end

  # GET /task_lists/1/edit
  def edit
  end

  # POST /task_lists or /task_lists.json
  def create
    @task_list = current_user.task_lists.new(task_list_params.except(:user_id))

    respond_to do |format|
      if @task_list.save
        format.html { redirect_to home_path, notice: "Task list criada com sucesso!" }
        format.json { render :show, status: :created, location: @task_list }
      else
        format.html { redirect_to home_path, alert: "Erro ao criar lista de tarefas :/" }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_lists/1 or /task_lists/1.json
  def update
    respond_to do |format|
      if @task_list.update(task_list_params)
        format.html { redirect_to @task_list, notice: "Task list was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @task_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_lists/1 or /task_lists/1.json
  def destroy
    @task_list.destroy!

    respond_to do |format|
      format.html { redirect_to task_lists_path, notice: "Task list was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_list
      @task_list = TaskList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_list_params
      params.require(:task_list).permit(:name)
    end

    # Only allow users to handle their own tasklists 
    def require_ownership
      redirect_to task_lists_path, alert: "Acesso negado." unless @task_list.user == current_user
    end
end

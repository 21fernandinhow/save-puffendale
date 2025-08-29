class TaskListsController < ApplicationController
  before_action :require_login
  before_action :set_task_list, only: %i[ show edit update destroy ]

  # GET /task_lists or /task_lists.json
  def index
    @task_lists = TaskList.all
  end

  # GET /task_lists/1 or /task_lists/1.json
  def show
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
    @task_list = TaskList.new(task_list_params)

    respond_to do |format|
      if @task_list.save
        format.html { redirect_to @task_list, notice: "Task list was successfully created." }
        format.json { render :show, status: :created, location: @task_list }
      else
        format.html { render :new, status: :unprocessable_entity }
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
      params.require(:task_list).permit(:name, :user_id)
    end
end

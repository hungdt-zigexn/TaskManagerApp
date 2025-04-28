class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = Task.includes(:tags)

    # Filter by status
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?

    # Filter by due date
    @tasks = @tasks.where("due_date <= ?", params[:due_date]) if params[:due_date].present?

    # Filter by tag
    @tasks = @tasks.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?

    # Sort
    case params[:sort]
    when "due_date"
      @tasks = @tasks.order(due_date: :asc)
    when "title"
      @tasks = @tasks.order(title: :asc)
    when "status"
      @tasks = @tasks.order(status: :desc)
    else
      @tasks = @tasks.order(created_at: :desc)
    end

    # Pagination
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully deleted."
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :tag_list)
  end
end

class TasksController < ApplicationController
  before_action :set_task, only: [ :show, :edit, :update, :destroy ]

  def index
    @tasks = Task.includes(:tags, :taggings)
                 .by_status(params[:status])
                 .due_before(params[:due_date])
                 .by_tag(params[:tag])
                 .sort_by_field(params[:sort])
                 .page(params[:page])
                 .per(10)

    # Preload counts for performance metrics
    @total_tasks = Task.count
    @completed_tasks = Task.by_status(true).count
    @pending_tasks = Task.by_status(false).count
  end

  def show
    # @task already includes tags from set_task method
  end

  def new
    @task = Task.new
    # Preload available tags for the form
    @available_tags = Tag.order(:name)
  end

  def edit
    # Preload available tags for the form
    @available_tags = Tag.order(:name)
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      @available_tags = Tag.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      @available_tags = Tag.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully deleted."
  end

  private

  def set_task
    @task = Task.includes(:tags).find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date, :tag_list)
  end
end

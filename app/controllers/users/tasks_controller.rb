module Users
  class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
    before_action :authorize_user!
    before_action :set_task, only: %i[ show update destroy ]

    def index
      tasks = @user.tasks.order(created_at: :desc)
      render json: tasks, each_serializer: TaskSerializer
    end

    def show
      render json: @task, serializer: TaskSerializer
    end

    def create
      task = @user.tasks.new(task_params)
      if task.save
        render json: task, serializer: TaskSerializer, status: :created
      else
        render json: { error: "Validation Failed", details: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        render json: @task, serializer: TaskSerializer
      else
        render json: { error: "Validation Failed", details: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @task.destroy
      head :no_content
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def authorize_user!
      return if current_user && current_user.id == @user.id
      render json: { error: "Forbidden" }, status: :forbidden
    end

    def set_task
      @task = @user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :status, :due_date)
    end
  end
end

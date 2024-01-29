class TasksController < ApplicationController
    before_action :find_task, except: [:create, :index]
    
    def create
        @task = Task.new(task_params)
        if @task.save
            render json: @task, status: :created
        else
            render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def index
        @tasks = Task.all
        render json: @tasks, status: :ok
    end


    def show
        render json: @task, status: :ok
    end


    def update
        if @task.update(task_params)
            render json: @task, status: :ok
        else
            render :edit, status: :unprocessable_entity
        end
    end


    def destroy
        @task.destroy
    end

    private
        def find_task
            @task = Task.find_by(id: params[:id])
            rescue ActiveRecord::RecordNotFound
            render json: { errors: 'Task not found' }, status: :not_found
        end

        def task_params
            params.require(:task).permit(:title, :body)
        end
end

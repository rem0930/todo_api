class TodosController < ApplicationController
    before_action :set_todo, only: [:show, :update, :destroy]

    # GET /todos
    def index
        @todos = Todo.all
        render json: @todos
    end

    # GET /todos/1
    def show
        render json:@todos
    end

    def create
        @todo = Todo.new(todo_params)

        if @todo.save
            render json: { todo: @todo }, status: :created
        else
            render json: { error: @todo.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @todo.update(todo_params)
            render json: @todo
        else
            render json: @todo.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @todo.destroy
    end

    private

        def set_todo
            @todo = Todo.find(params[:id])
        end

        def todo_params
            params.require(:todo).permit(:title)
        end
end

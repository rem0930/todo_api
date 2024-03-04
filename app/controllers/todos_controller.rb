class TodosController < ApplicationController
    before_action :authenticate_user
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

    # POST /todos
    def create
        @todo = Todo.new(todo_params)

        if @todo.save
            render json: { todo: @todo }, status: :created
        else
            render json: { error: @todo.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /todos/1
    def update
        if @todo.update(todo_params)
            render json: @todo
        else
            render json: @todo.errors, status: :unprocessable_entity
        end
    end

    # DELETE /todos/1
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

        def authenticate_user
            puts "sss"
            token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.fOf4accuwGzYqu02mgPV95HNhZXjHA_8YAi0k5Wu-vE'"
            # request.headers['Authorization']&.split(' ')&.last
            puts "Aaa"
            puts token
            if token
                decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base,
                                            true, algorithm: 'HS256')
                user_id = decoded_token.first['user_id']
                @curretnt_user = User.find_by(id: user_id)
                render json: { error: 'Unauthorized' }, status: :unauthorized unless @curretnt_user
            else
                puts "else"
                render json: { error: 'Unauthorized' }, status: :unauthorized
            end
        rescue JWT::DecodeError
            render json: { error: 'Unauthorized' }, status: :unauthorized
        end
end

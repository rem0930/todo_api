class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:user][:email])
        if user && user.authenticate(params[:user][:password])
            token = generate_token(user.id)
            puts "Aaaa"
            puts token
            render json: { user: { email: user.email, token: token } }, status: :ok
        else
            render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end

    private
        def generate_token(user_id)
            payload = { user_id: user_id }
            JWT.encode(payload, Rails.application.credentials.secret_key_base)
        end
end

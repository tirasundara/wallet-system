module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate, only: :create

      def create
        result = Auth::AuthenticationService.call(
          email: params[:email],
          password: params[:password]
        )

        if result
          render json: {
            token: result[:token],
            user: result[:user].as_json(except: :password_digest)
          }, status: :ok
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end
    end
  end
end

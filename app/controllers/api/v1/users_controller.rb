module Api
  module V1
    class UsersController < ApplicationController
      def show
        render json: current_user.as_json(
          except: :password_digest,
          include: { wallet: { only: [ :id, :balance ] } }
        )
      end
    end
  end
end

module Api
  module V1
    class WalletsController < ApplicationController
      before_action :set_wallet, only: [ :show ]

      def show
        render json: @wallet
      end

      private

      def set_wallet
        @wallet = Wallet.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Wallet not found" }, status: :not_found
      end
    end
  end
end

module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :set_wallet, only: [ :index, :deposit, :withdraw ]

      def index
        transactions = Transaction.where(
          "source_wallet_id = ? OR target_wallet_id = ?",
          @wallet.id,
          @wallet.id
        ).order(created_at: :desc)

        render json: transactions.as_json(methods: :type)
      end

      def deposit
        result = TransactionServices::DepositService.call(
          wallet: @wallet,
          amount: params[:amount],
          description: params[:description]
        )

        if result[:success]
          render json: result[:transaction], status: :created
        else
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      end

      def withdraw
        result = TransactionServices::WithdrawalService.call(
          wallet: @wallet,
          amount: params[:amount],
          description: params[:description]
        )

        if result[:success]
          render json: result[:transaction], status: :created
        else
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      end

      def transfer
        source_wallet = Wallet.find(params[:source_wallet_id])
        target_wallet = Wallet.find(params[:target_wallet_id])

        result = TransactionServices::TransferService.call(
          source_wallet: source_wallet,
          target_wallet: target_wallet,
          amount: params[:amount],
          description: params[:description]
        )

        if result[:success]
          render json: result[:transaction], status: :created
        else
          render json: { error: result[:errors] }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "One or both wallets not found" }, status: :not_found
      end

      private

      def set_wallet
        @wallet = Wallet.find(params[:wallet_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Wallet not found" }, status: :not_found
      end
    end
  end
end

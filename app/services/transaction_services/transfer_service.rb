module TransactionServices
  class TransferService < BaseTransactionService
    attr_reader :source_wallet, :target_wallet

    def initialize(source_wallet:, target_wallet:, amount:, description: nil)
      super(amount: amount, description: description)
      @source_wallet = source_wallet
      @target_wallet = target_wallet
    end

    def call
      return @result unless validate_amount && validate_different_wallets && validate_balance

      execute_transaction
    end

    private

    def validate_different_wallets
      return true if source_wallet.id != target_wallet.id

      @result[:errors] = "Source and target wallets must be different"
      false
    end

    def validate_balance
      return true if source_wallet.balance >= amount

      @result[:errors] = "Insufficient balance in source wallet"
      false
    end

    def build_transaction
      TransferTransaction.new(
        source_wallet_id: source_wallet.id,
        target_wallet_id: target_wallet.id,
        amount: amount,
        description: description
      )
    end
  end
end

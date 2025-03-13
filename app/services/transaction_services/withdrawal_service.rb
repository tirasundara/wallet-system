module TransactionServices
  class WithdrawalService < BaseTransactionService
    attr_reader :wallet

    def initialize(wallet:, amount:, description: nil)
      super(amount: amount, description: description)
      @wallet = wallet
    end

    def call
      return @result unless validate_amount && validate_balance

      execute_transaction
    end

    private

    def validate_balance
      return true if wallet.balance >= amount

      @result[:errors] = "Insufficient balance"
      false
    end

    def build_transaction
      DebitTransaction.new(
        source_wallet_id: wallet.id,
        amount: amount,
        description: description
      )
    end
  end
end

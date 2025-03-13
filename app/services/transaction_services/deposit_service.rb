module TransactionServices
  class DepositService < BaseTransactionService
    attr_reader :wallet

    def initialize(wallet:, amount:, description: nil)
      super(amount: amount, description: description)
      @wallet = wallet
    end

    def call
      return @result unless validate_amount

      execute_transaction
    end

    private

    def build_transaction
      CreditTransaction.build(
        target_wallet_id: wallet.id,
        amount: amount,
        description: description
      )
    end
  end
end

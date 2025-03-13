module TransactionServices
    class BaseTransactionService < ApplicationService
        attr_reader :amount, :description, :result

        def initialize(amount:, description: nil)
            @amount = amount.to_f
            @description = description
            @result = { success: false, transaction: nil, errors: nil }
        end

        private

        def validate_amount
            return true if amount.present? && amount.positive?

            @result[:errors] = "Amount must be present and positive"
            false
        end

        def execute_transaction
            ActiveRecord::Base.transaction do
                # the `#build_transaction` method is defined in child classes
                # since each transaction has different params
                @transaction = build_transaction

                if @transaction.save
                    @result[:success] = true
                    @result[:transaction] = @transaction
                else
                    @result[:errors] = @transaction.errors.full_messages
                    raise ActiveRecord::Rollback
                end
            end

            @result
        end
    end
end

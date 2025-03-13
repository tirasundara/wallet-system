class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :valid_transaction_type
  validate :sufficient_funds, if: -> { source_wallet.present? }

  # Update wallets balance after each transaction
  after_create :update_wallet_balances

  # STI for different transaction types
  def self.inherited(child)
      child.instance_eval do
          def model_name
              Transaction.model_name
          end
      end
      super
  end

  private

  def valid_transaction_type
      if source_wallet.present? && target_wallet.present?
      # Transfer - both source and target
      elsif source_wallet.present? && target_wallet.nil?
      # Withdrawal - source only
      elsif source_wallet.nil? && target_wallet.present?
      # Deposit - target only
      else
      errors.add(:base, "Invalid transaction: both source and target wallets can't be nil")
      end
  end

  def sufficient_funds
      return if source_wallet.nil?

      if source_wallet.balance < amount
      errors.add(:amount, "Insufficient funds in source wallet")
      end
  end

  def update_wallet_balances
    ActiveRecord::Base.transaction do
      source_wallet&.update_balance!
      target_wallet&.update_balance!
    end
  end
end

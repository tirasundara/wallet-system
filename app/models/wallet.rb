class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :credit_transactions, class_name: "Transaction", foreign_key: "target_wallet_id"
  has_many :debit_transactions, class_name: "Transaction", foreign_key: "source_wallet_id"

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def calculate_balance
      credit_sum = credit_transactions.sum(:amount)
      debit_sum = debit_transactions.sum(:amount)
      credit_sum - debit_sum
  end

  def update_balance!
      update!(balance: calculate_balance)
  end
end

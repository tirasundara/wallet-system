class CreditTransaction < Transaction
    validates :source_wallet, absence: true
    validates :target_wallet, presence: true
end

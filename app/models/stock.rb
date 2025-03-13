class Stock < ApplicationRecord
    has_one :wallet, as: :owner, dependent: :destroy

    validates :symbol, presence: true, uniqueness: true
    validates :name, presence: true

    after_create :create_wallet

    private

    def create_wallet
        create_wallet! unless wallet
    end
end

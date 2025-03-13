class User < ApplicationRecord
    has_one :wallet, as: :owner, dependent: :destroy
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true

    after_create :create_wallet

    private

    def create_wallet
        create_wallet! unless wallet
    end
end

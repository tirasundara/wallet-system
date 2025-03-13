module Auth
  class AuthenticationService < ApplicationService
    attr_reader :email, :password

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def call
      return nil unless user
      return nil unless user.authenticate(password)

      token = TokenService.encode(user_id: user.id)
      { user: user, token: token }
    end

    private

    def user
      @user ||= User.find_by(email: email)
    end
  end
end

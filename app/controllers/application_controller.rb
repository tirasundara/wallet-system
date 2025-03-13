class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    @current_user = nil

    authenticate_with_http_token do |token, options|
      payload = Auth::TokenService.decode(token)
      @current_user = User.find(payload[:user_id]) if payload
    end
  end

  def current_user
    @current_user
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end

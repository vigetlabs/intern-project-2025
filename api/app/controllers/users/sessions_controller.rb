# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200, message: "Logged in successfully.",
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end
  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, ENV.fetch("DEVISE_JWT_SECRET_KEY")).first
      current_user = User.find_by(id: jwt_payload["sub"], jti: jwt_payload["jti"])
    end

    if current_user
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end

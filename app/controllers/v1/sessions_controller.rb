# app/controllers/v1/sessions_controller.rb
module V1
  class SessionsController < ApplicationController
    def create
      user = User.find_by(name: params.dig(:user, :name))

      if user&.authenticate(params.dig(:user, :password))
        token = encode_token({ user_id: user.id })
        render json: { token: token }, status: :ok
      else
        render json: { error: "Invalid name or password" }, status: :unauthorized
      end
    end

    private

    def encode_token(payload)
      JWT.encode(payload, Rails.application.secret_key_base)
    end
  end
end

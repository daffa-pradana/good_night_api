module V1
  class SessionsController < ApplicationController
    skip_before_action :authorize_request

    def create
      user = User.find_by(name: params.dig(:user, :name))

      if user&.authenticate(params.dig(:user, :password))
        token = JsonWebToken.encode({ user_id: user.id })
        render json: { token: token }, status: :ok
      else
        render json: { error: "Invalid name or password" }, status: :unauthorized
      end
    end
  end
end

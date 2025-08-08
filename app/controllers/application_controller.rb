class ApplicationController < ActionController::API
  include Paginated

  before_action :authorize_request

  private

  def authorize_request
    token = request.headers["Authorization"]&.split(" ")&.last
    payload = JsonWebToken.decode(token)
    @current_user = User.find(payload[:user_id])
  rescue
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end

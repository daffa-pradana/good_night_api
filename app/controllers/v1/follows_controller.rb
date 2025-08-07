class V1::FollowsController < ApplicationController
  before_action :authorize_request

  def create
    user = User.find(params[:followed_id])
    @current_user.following << user unless @current_user.following.exists?(user.id)
    render json: { message: "Followed #{user.name}" }
  end

  def destroy
    user = User.find(params[:followed_id])
    @current_user.following.destroy(user)
    render json: { message: "Unfollowed #{user.name}" }
  end
end

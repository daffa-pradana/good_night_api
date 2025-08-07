class ApplicationController < ActionController::API
  before_action :authenticate_user_from_token!, unless: :devise_controller?
  before_action :authenticate_user!
end

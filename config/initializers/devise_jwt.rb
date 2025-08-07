# config/initializers/devise_jwt.rb

Devise::JWT.configure do |config|
  config.expiration_time = 24.hours
  config.secret = ENV["DEVISE_JWT_SECRET_KEY"]
end

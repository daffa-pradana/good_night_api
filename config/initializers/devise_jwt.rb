# config/initializers/devise_jwt.rb

Devise::Jwt.configure do |config|
  config.expiration_time = 24.hours
  config.secret = ENV["DEVISE_JWT_SECRET_KEY"]
end

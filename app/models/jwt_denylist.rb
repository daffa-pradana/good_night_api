class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
end

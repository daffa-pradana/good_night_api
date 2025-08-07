class User < ApplicationRecord
  devise :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :name, presence: true, uniqueness: true

  def self.find_for_database_authentication(warden_conditions)
    find_by(name: warden_conditions[:name].downcase)
  end
end

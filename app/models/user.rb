class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  validates :name, presence: true, uniqueness: true

  before_create :set_jti

  def self.find_for_database_authentication(warden_conditions)
    find_by(name: warden_conditions[:name].downcase)
  end

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end

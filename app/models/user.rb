# app/models/user.rb
class User < ApplicationRecord
  has_secure_password

  before_create :generate_token

  validates :name, presence: true, uniqueness: true

  has_many :sleep_trackers, dependent: :destroy

  private

  def generate_token
    self.token = SecureRandom.hex(20)
  end
end

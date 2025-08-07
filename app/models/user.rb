# app/models/user.rb
class User < ApplicationRecord
  has_secure_password

  before_create :generate_token

  validates :name, presence: true, uniqueness: true

  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  has_many :sleep_trackers

  private

  def generate_token
    self.token = SecureRandom.hex(20)
  end
end

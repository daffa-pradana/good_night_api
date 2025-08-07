class SleepTracker < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where.not(clock_in: nil).where.not(clock_out: nil) }

  def calculate_duration!
    update(duration: (clock_out - clock_in).to_i) if clock_in && clock_out
  end
end

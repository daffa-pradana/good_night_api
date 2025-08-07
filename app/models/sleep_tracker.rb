class SleepTracker < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where.not(clocked_in_at: nil).where.not(clocked_out_at: nil) }

  def calculate_duration!
    update(duration: (clocked_out_at - clocked_in_at).to_i) if clocked_in_at && clocked_out_at
  end
end

class SleepTracker < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where.not(clocked_in_at: nil).where.not(clocked_out_at: nil) }

  def calculate_duration!
    return unless clocked_in_at.present? && clocked_out_at.present?

    duration_seconds = (clocked_out_at.to_i - clocked_in_at.to_i)
    update!(duration: duration_seconds)
  end

  def duration_in_words
    return nil unless duration.present? && duration > 0

    total_minutes = duration / 60
    hours = total_minutes / 60
    minutes = total_minutes % 60

    parts = []
    parts << "#{hours} hour#{'s' if hours != 1}" if hours > 0
    parts << "#{minutes} minute#{'s' if minutes != 1}" if minutes > 0
    parts.join(" ")
  end
end

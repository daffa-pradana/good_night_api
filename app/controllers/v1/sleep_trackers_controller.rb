module V1
  class SleepTrackersController < ApplicationController
    before_action :authorize_request

    def toggle
      last_tracker = @current_user.sleep_trackers.order(created_at: :desc).first

      if last_tracker.nil? || last_tracker.clocked_out_at.present?
        tracker = @current_user.sleep_trackers.create!(clocked_in_at: Time.current)
        render json: { status: "clocked_in", tracker: tracker }, status: :created
      else
        last_tracker.update!(clocked_out_at: Time.current)
        last_tracker.calculate_duration!
        render json: { status: "clocked_out", tracker: last_tracker }, status: :ok
      end
    end

    def followed
      latest_records = SleepTracker
        .joins("INNER JOIN follows ON follows.followed_id = sleep_trackers.user_id")
        .where(follows: { follower_id: @current_user.id })
        .where("sleep_trackers.clocked_in_at >= ?", 1.week.ago)
        .where.not(sleep_trackers: { clocked_out_at: nil })
        .select("DISTINCT ON (sleep_trackers.user_id) sleep_trackers.*")
        .order("sleep_trackers.user_id, sleep_trackers.clocked_in_at DESC")

      sorted_records = SleepTracker
        .from(latest_records, :sleep_trackers)
        .order(duration: :desc)

      render json: sorted_records.map { |record|
        {
          user: {
            id: record.user.id,
            name: record.user.name
          },
          sleep_record: {
            id: record.id,
            clocked_in_at: record.clocked_in_at,
            clocked_out_at: record.clocked_out_at,
            duration: record.duration_in_words,
          }
        }
      }
    end
  end
end

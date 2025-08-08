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
      sleep_records = followed_sleep_records
      sleep_records = SleepTracker
        .from(sleep_records, :sleep_trackers)
        .order(duration: :desc)
      sleep_records = paginate(sleep_records)

      render json: sleep_records.map { |record|
        {
          user: {
            id: record.user.id,
            name: record.user.name
          },
          sleep_record: {
            clocked_in_at: record.clocked_in_at,
            clocked_out_at: record.clocked_out_at,
            duration: record.duration_in_words
          }
        }
      }
    end

    private

    def followed_sleep_records
      SleepTracker
        .joins("INNER JOIN follows ON follows.followed_id = sleep_trackers.user_id")
        .where(follows: { follower_id: @current_user.id })
        .where("sleep_trackers.clocked_in_at >= ?", 1.week.ago)
        .where.not(sleep_trackers: { clocked_out_at: nil })
        .select("DISTINCT ON (sleep_trackers.user_id) sleep_trackers.*")
        .order("sleep_trackers.user_id, sleep_trackers.clocked_in_at DESC")
    end
  end
end

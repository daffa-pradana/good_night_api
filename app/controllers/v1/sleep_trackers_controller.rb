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
      sleep_records =
        SleepTracker
          .from(followed_sleep_records, :sleep_trackers)
          .order(duration: :desc)
      sleep_records = paginate(sleep_records)

      render json: array_json(sleep_records)
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

    def array_json(result)
      SleepRecordPresenter.as_array_json(result)
    end
  end
end

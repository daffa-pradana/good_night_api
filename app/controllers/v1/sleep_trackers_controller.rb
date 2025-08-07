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
      one_week_ago = 1.week.ago

      followed_user_ids = @current_user.following.pluck(:id)

      latest_records = SleepTracker
                        .where(user_id: followed_user_ids)
                        .where("clocked_in_at >= ?", one_week_ago)
                        .where.not(clocked_out_at: nil)
                        .select("DISTINCT ON (user_id) *")
                        .order("user_id, clocked_in_at DESC")

      sorted = latest_records.sort_by(&:duration).reverse

      render json: sorted.map { |record|
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

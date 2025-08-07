module V1
  class SleepTrackersController < ApplicationController
    before_action :authorize_request

    def toggle
      last_tracker = @current_user.sleep_trackers.order(created_at: :desc).first

      if last_tracker.nil? || last_tracker.clocked_out_at.present?
        # Clock in
        tracker = @current_user.sleep_trackers.create!(clocked_in_at: Time.current)
        render json: { status: "clocked_in", tracker: tracker }, status: :created
      else
        # Clock out
        last_tracker.update!(clocked_out_at: Time.current)
        last_tracker.calculate_duration!
        render json: { status: "clocked_out", tracker: last_tracker }, status: :ok
      end
    end
  end
end

class OptimizeCompletedSleepTrackersIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :sleep_trackers,
              [ :user_id, :clocked_in_at ],
              order: { clocked_in_at: :desc },
              where: "clocked_out_at IS NOT NULL",
              name: "index_sleep_trackers_on_user_and_clockedin_completed"
  end
end

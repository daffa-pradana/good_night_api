class CreateSleepTrackers < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_trackers do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :clocked_in_at
      t.datetime :clocked_out_at
      t.integer :duration

      t.timestamps
    end
  end
end

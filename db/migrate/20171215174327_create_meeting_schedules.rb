class CreateMeetingSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :meeting_schedules do |t|
      t.datetime :start_time
      t.text :recurring
      t.references :team_member, foreign_key: true

      t.timestamps
    end
  end
end

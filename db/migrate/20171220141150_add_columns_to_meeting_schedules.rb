class AddColumnsToMeetingSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :meeting_schedules, :every, :integer
    add_column :meeting_schedules, :frequency, :string
    add_column :meeting_schedules, :day_of_week, :string
  end
end

class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.datetime :date
      t.references :meeting_schedule, foreign_key: true
      t.references :team_member, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end

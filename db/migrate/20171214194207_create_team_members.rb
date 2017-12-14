class CreateTeamMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :team_members do |t|
      t.string :role, null: false, default: "employee"
      t.references :user, foreign_key: true
      t.references :team, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end

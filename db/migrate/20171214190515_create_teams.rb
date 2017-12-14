class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.references :organization, foreign_key: true

      t.timestamps
    end

    add_index :teams, [:name, :organization_id], unique: true
  end
end

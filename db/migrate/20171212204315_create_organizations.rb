class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :name, unique: true
      t.string :time_zone

      t.timestamps
    end
  end
end

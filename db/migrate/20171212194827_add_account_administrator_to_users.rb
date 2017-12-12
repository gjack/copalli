class AddAccountAdministratorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :account_administrator, :boolean, default: false, null: false
  end
end

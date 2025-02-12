class AddUsernameToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :username, :string, null: false
    add_index :customers, :username, unique: true
  end
end

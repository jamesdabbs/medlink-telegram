class AddMedlinkTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :medlink_token, :string
  end
end

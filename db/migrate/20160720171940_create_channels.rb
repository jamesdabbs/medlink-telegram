class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.string :name, index: true, unique: true
      t.string :chat_id

      t.timestamps
    end
  end
end

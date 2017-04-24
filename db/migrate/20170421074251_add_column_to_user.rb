class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :owner_room_id, foreign_key: {to_table: :rooms}
    add_reference :users, :guest_room_id, foreign_key: {to_table: :rooms}
  end
end

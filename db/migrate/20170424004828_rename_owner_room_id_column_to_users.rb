class RenameOwnerRoomIdColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :users, :rooms
    remove_reference :users, :owner_room_id
    remove_reference :users, :guest_room_id
    add_reference :users, :owner_room, foreign_key: {to_table: :rooms}
    add_reference :users, :guest_room, foreign_key: {to_table: :rooms}
  end
end

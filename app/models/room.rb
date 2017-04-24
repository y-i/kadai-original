class Room < ApplicationRecord
  has_many :users
  has_many :owner, class_name: 'User', foreign_key: 'owner_room_id', :dependent => :nullify
  has_many :guest, class_name: 'User', foreign_key: 'guest_room_id', :dependent => :nullify

  validates :comment, presence: true, length: {maximum: 100}
end

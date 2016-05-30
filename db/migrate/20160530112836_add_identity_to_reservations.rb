class AddIdentityToReservations < ActiveRecord::Migration
  def self.up
    add_column :reservations, :identity, :string
  end
  
  def self.down
    remove_column :reservations, :identity
  end
end

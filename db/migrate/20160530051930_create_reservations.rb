class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :userName
      t.integer :resvType

      t.timestamps null: false
    end
  end
end

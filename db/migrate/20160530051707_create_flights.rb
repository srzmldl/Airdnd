class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.string :flightNum
      t.integer :price
      t.integer :numSeats
      t.integer :numAvail
      t.string :FromCity
      t.string :ArivCity

      t.timestamps null: false
    end
  end
end

class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :location
      t.integer :price
      t.integer :numCars
      t.integer :numAvail

      t.timestamps null: false
    end
  end
end

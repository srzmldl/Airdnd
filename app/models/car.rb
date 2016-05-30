class Car < ActiveRecord::Base
   validates :location, :presence => true,
            :length => { :within => 1..100 },
            :uniqueness => true
  validate :numAvail_cannot_be_greater_than_numCars


  def numAvail_cannot_be_greater_than_numCars
    if numAvail > numCars
      errors.add(:numAvail, "cannot greatter than numCars")
    end
  end
  
end

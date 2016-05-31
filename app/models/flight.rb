class Flight < ActiveRecord::Base
  
   validates :flightNum, :presence => true,
            :length => { :within => 1..100 },
            :uniqueness => true
  validate :numAvail_cannot_be_greater_than_numSeats


  def numAvail_cannot_be_greater_than_numSeats
    if numAvail > numSeats
      errors.add(:numAvail, "cannot greatter than numSeats")
    end
  end
end

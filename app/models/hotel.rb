class Hotel < ActiveRecord::Base
  validates :location, :presence => true,
            :length => { :within => 1..100 },
            :uniqueness => true
  validate :numAvail_cannot_be_greater_than_numRooms


  def numAvail_cannot_be_greater_than_numRooms
    if numAvail > numRooms
      errors.add(:numAvail, "cannot greatter than numRooms")
    end
  end
  
end

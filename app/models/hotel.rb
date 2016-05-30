class Hotel < ActiveRecord::Base
  validates :location, :presence => true,
            :length => { :within => 1..100 },
            :uniqueness => true
end

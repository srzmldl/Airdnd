class Reservation < ActiveRecord::Base
  
  class << self
    def create_order(name = '', resvType = 0, identity = '')
      return Reservation.create(userName: name, resvType: resvType, identity: identity)
    end
    
    def list_single_user(name = '')
      resvListTmp = Reservation.where(userName: name)
      resvList = []
      resvListTmp.each do|t|
        resvList.push(t)
      end
      return resvList
    end
    
  end
end
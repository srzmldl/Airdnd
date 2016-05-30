class HotelsController < ApplicationController
  before_filter :admin_user, :only => [:destroy, :edit, :update, :create]

  def show
  end
  
  def new
    @hotel = Hotel.new
    @title = "Add hotel"
  end

  def index
    @title = "All hotels"
    @hotels = Hotel.paginate(:page => params[:page])
  end

  def create
    #debugger
    @hotel = Hotel.new(hotel_params)
    if @hotel.save
      flash[:success] = "Add hotel success"
      redirect_to hotels_path
    else
      @title = "Add hotel"
      render 'new'
    end
  end

  def edit
    @hotel = Hotel.find(params[:id])
    @title = "Edit hotel"
  end

  def update
    @hotel = Hotel.find(params[:format])
    if @hotel.update_attributes(hotel_params)
      flash[:success] = "Hotel updated"
      redirect_to hotels_path
    else
      @title = "Edit hotel"
      render 'edit'
    end
  end

  def order
#    debugger
    @hotel = Hotel.find(params[:format])
    if @hotel.numAvail > 0
      if signed_in? == false
        redirect_to signin_path, :notice => "Please sign in to order"
        return
      end
      if Reservation.create_order(current_user.name, 2, @hotel.location) == nil
        flash[:error] = "create reservation error due to mystery reason"
        redirect_to hotels_path
        return
      end
      @hotel.numAvail = @hotel.numAvail - 1
      @hotel.save
      flash[:success] = "Hotel " + @hotel.location + " Order Success"
      redirect_to hotels_path
    else
      flash[:error] = "No room available in hotel " + @hotel.location
      redirect_to hotels_path
    end
  end

  def destroyOrder
    tripTmp = Reservation.find(params[:format])
    hotelTmp = Hotel.find_by_location(tripTmp.identity)
    tripTmp.destroy
    hotelTmp.numAvail = hotelTmp.numAvail + 1;
    hotelTmp.save
    flash[:success] = "Hotel order destroyed."
    redirect_to manage_trip_path
  end

  def destroy
    Hotel.find(params[:id]).destroy
    flash[:success] = "Hotel destroyed."
    redirect_to hotels_path
  end

  private
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def hotel_params
    params.require(:hotel).permit(:location, :price, :numRooms, :numAvail)
  end
  
end

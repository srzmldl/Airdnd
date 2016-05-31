class FlightsController < ApplicationController
  before_filter :admin_user, :only => [:destroy, :edit, :update, :create]

  def show
  end
  
  def new
    @flight = Flight.new
    @title = "Add Flight"
  end

  def index
    @title = "All Flights"
    @flights = Flight.paginate(:page => params[:page])
  end

  def create
    #debugger
    @flight = Flight.new(flight_params)
    if @flight.save
      flash[:success] = "Add flight success"
      redirect_to flights_path
    else
      @title = "Add flight"
      render 'new'
    end
  end

  def edit
    @flight = Flight.find(params[:id])
    @title = "Edit flight"
  end

  def update
    @flight = Flight.find(params[:id])
    if @flight.update_attributes(flight_params)
      flash[:success] = "Flight updated"
      redirect_to flights_path
    else
      @title = "Edit flight"
      render 'edit'
    end
  end

  def order
    #    debugger
    @flight = Flight.find(params[:format])
    if @flight.numAvail > 0
      if signed_in? == false
        redirect_to signin_path, :notice => "Please sign in to order"
        return
      end
      if Reservation.create_order(current_user.name, 1, @flight.flightNum) == nil
        flash[:error] = "create reservation error due to mystery reason"
        redirect_to flights_path
        return
      end
      @flight.numAvail = @flight.numAvail - 1
      @flight.save
      flash[:success] = "Flight " + @flight.flightNum + " Order Success"
      redirect_to flights_path
    else
      flash[:error] = "No room available in flight " + @flight.flightNum
      redirect_to flights_path
    end
  end

  def destroyOrder
    tripTmp = Reservation.find(params[:format])
    flightTmp = Flight.find_by_flightNum(tripTmp.identity)
    tripTmp.destroy
    if (flightTmp == nil)
      redirect_to manage_trip_path
      return
    end
    flightTmp.numAvail = flightTmp.numAvail + 1;
    flightTmp.save
    flash[:success] = "Flight order destroyed."
    redirect_to manage_trip_path
  end

  def destroy
    Flight.find(params[:id]).destroy
    flash[:success] = "Flight destroyed."
    redirect_to flights_path
  end

  private
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def flight_params
    params.require(:flight).permit(:flightNum, :price, :numSeats, :numAvail, :FromCity, :ArivCity)
  end
end

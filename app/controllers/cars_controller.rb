class CarsController < ApplicationController
  before_filter :admin_user, :only => [:destroy, :edit, :update, :create]

  def show
  end
  
  def new
    @car = Car.new
    @title = "Add Car"
  end

  def index
    @title = "All Cars"
    @cars = Car.paginate(:page => params[:page])
  end

  def create
    #debugger
    @car = Car.new(car_params)
    if @car.save
      flash[:success] = "Add car success"
      redirect_to cars_path
    else
      @title = "Add car"
      render 'new'
    end
  end

  def edit
    @car = Car.find(params[:id])
    @title = "Edit car"
  end

  def update
    @car = Car.find(params[:id])
    if @car.update_attributes(car_params)
      flash[:success] = "Car updated"
      redirect_to cars_path
    else
      @title = "Edit car"
      render 'edit'
    end
  end

  def order
    #    debugger
    @car = Car.find(params[:format])
    if @car.numAvail > 0
      if signed_in? == false
        redirect_to signin_path, :notice => "Please sign in to order"
        return
      end
      if Reservation.create_order(current_user.name, 3, @car.location) == nil
        flash[:error] = "create reservation error due to mystery reason"
        redirect_to cars_path
        return
      end
      @car.numAvail = @car.numAvail - 1
      @car.save
      flash[:success] = "Car " + @car.location + " Order Success"
      redirect_to cars_path
    else
      flash[:error] = "No room available in car " + @car.location
      redirect_to cars_path
    end
  end

  def destroyOrder
    tripTmp = Reservation.find(params[:format])
    carTmp = Car.find_by_location(tripTmp.identity)
    tripTmp.destroy  
    if (carTmp == nil)
      redirect_to manage_trip_path
      return
    end
    carTmp.numAvail = carTmp.numAvail + 1;
    carTmp.save
    flash[:success] = "Car order destroyed."
    redirect_to manage_trip_path
  end

  def destroy
    Car.find(params[:id]).destroy
    flash[:success] = "Car destroyed."
    redirect_to cars_path
  end

  private
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def car_params
    params.require(:car).permit(:location, :price, :numCars, :numAvail)
  end
  
end

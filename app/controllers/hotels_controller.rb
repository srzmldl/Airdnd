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
    @hotel = Hotel.find(params[:id])
    if @hotel.update_attributes(user_paramse)
      flash[:success] = "Hotel updated"
      redirect_to @hotel
    else
      @title = "Edit hotel"
      render 'edit'
    end
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

# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy, :tripManage]

  def tripList
  #  debugger
    if signed_in? == false
      redirect_to signin_path, :notice => "Please sign in to look your trips"
      return
    end
    @userNameTrips = params[:format]
    allTrip = Reservation.list_single_user(params[:format])
    @hotelsTrip = []
    @flightsTrip = []
    @carsTrip = []
    transferIndividual(allTrip)
  end

  def tripManage
    @allTrips = Reservation.all;
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
   # debugger
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      flash[:success] = "Welcome to airdnd"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def transferIndividual(allTrip, userName = "")
#    debugger
    allTrip.each do |t|
      if t.resvType == 1
        tFlight = Flight.find_by_flightNum(t.identity)
        if tFlight != nil
          tFlight.id = t.id
          tFilght.userName = userName
          @flightsTrip.push(tFlight)
        end
      elsif t.resvType == 2
        #debugger
        tHotel = Hotel.find_by_location(t.identity)
        if tHotel != nil
          tHotel.id = t.id
          @hotelsTrip.push(tHotel)
        end
      elsif t.resvType == 3
        tCar = Car.find_by_location(t.identity)
        if tCar != nil
          tCar.id = t.id
          tCar.userName = userName
          @carsTrip.push(tCar)
        end
      end
    end
  end

end

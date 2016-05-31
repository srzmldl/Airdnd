# coding: utf-8
require 'set'
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy, :tripManage]

  def tripList
    #debugger
    if signed_in? == false
      redirect_to signin_path, :notice => "Please sign in to look your trips"
      return
    end
    @userNameTrips = params[:format]
    allTrip = Reservation.list_single_user(params[:format])
    @hotelsTrip = []
    @flightsTrip = []
    @carsTrip = []
    @ifComplete = true
    @tripPath = ""
    transferIndividual(allTrip)
    checkComplete(@flightsTrip)
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

  def transferIndividual(allTrip)
#    debugger
    allTrip.each do |t|
      if t.resvType == 1
        tFlight = Flight.find_by_flightNum(t.identity)
        if tFlight != nil
          tFlight.id = t.id
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
       # debugger
        tCar = Car.find_by_location(t.identity)
        if tCar != nil
          tCar.id = t.id
          @carsTrip.push(tCar)
        end
      end
    end
  end

  def checkComplete(flightsTrip)
    nextCity = {}
    cityFlag = {}
    cityVis = {}
    s1 = Set.new()
    flightsTrip.each do |t|
      nextCity[t.FromCity] = t.ArivCity
      cityFlag[t.ArivCity] = true
      cityVis[t.FromCity] = false
      cityVis[t.ArivCity] = false
      s1.add(t.ArivCity)
      s1.add(t.FromCity)
    end
    if s1.empty?
      return
    end
    startCity = []
    cnt = 0
    s1.each do |t|
      if cityFlag[t] != true
        now = t
        cnt += 1
        nowPath = ""
        while now != nil || cityVis[now] == false
          cityVis[now] = true
          nowPath += now
          now = nextCity[now]
          if now != nil && cityVis[now] == false
            nowPath += '-->'
          end
        end
        nowPath += "||"
        @tripPath += nowPath
      end
    end

    s1.each do |t|
      if cityVis[t] == false
        now = t
        cnt += 1
        nowPath = ""
        while now != nil || cityVis[now] == false
          cityVis[now] = true
          nowPath += now
          now = nextCity[now]
          if now != nil && cityVis[now] == false
            nowPath += '-->'
          end
        end
        nowPath += "||"
        @tripPath += nowPath
      end
    end
    if cnt > 1
      @ifComplete = false
    end
  end

end

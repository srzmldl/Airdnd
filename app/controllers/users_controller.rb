# coding: utf-8
class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign up"
    
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
      flash[:success] = "欢迎来到全球最大的在线旅游平台airdnd"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

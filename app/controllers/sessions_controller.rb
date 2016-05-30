# coding: utf-8
class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
   # debugger
    user = User.authenticate(create_params[:name],
                             create_params[:password])
    if user.nil?
      flash.now[:error] = "error combination of name and password."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_to user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def create_params
   # debugger
    params.require(:session).permit(:name, :password)
  end
end

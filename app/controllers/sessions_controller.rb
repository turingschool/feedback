class SessionsController < ApplicationController

  def new
    @user ||= User.new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      cookies.signed[:feedback_user] = user.id
      if user.admin?
        redirect_to admin_invite_sets_path
      else
        redirect_to submissions_path
      end
    else
      flash[:error] = "Wrong Email or Password"
      redirect_to root_path
    end
  end

  def destroy
    session.clear
    cookies.delete :feedback_user
    flash[:success] = "Logout Successful"
    redirect_to root_path
  end
end

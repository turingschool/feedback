class SessionsController < ApplicationController

  def new
    @user ||= User.new
  end

  def oauth
    slack_info = request.env["omniauth.auth"]
    u_info = { name: slack_info["info"]["name"],
               email: slack_info["info"]["email"],
               slack_id: slack_info["uid"],
               admin: slack_info["info"]["is_admin"],
               slack_token: slack_info["credentials"]["token"],
               slack_name: slack_info["info"]["user"] }
    session[:user_info] = u_info
    redirect_to root_path
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

class SessionsController < ApplicationController
  def oauth
    slack_info = request.env["omniauth.auth"]
    if user = User.find_by(slack_id: slack_info["uid"])
      session[:user_id] = user.id
      redirect_to session[:return_to] || feedbacks_path
    else
      render text: "Sorry, @#{slack_info["info"]["user"]}, you have not been added to the feedback app yet."
    end
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
    flash[:success] = "Logout Successful"
    redirect_to root_path
  end
end

    # u_info = { name: slack_info["info"]["name"],
    #            email: slack_info["info"]["email"],
    #            slack_id: slack_info["uid"],
    #            admin: slack_info["info"]["is_admin"],
    #            slack_token: slack_info["credentials"]["token"],
    #            slack_name: slack_info["info"]["user"] }

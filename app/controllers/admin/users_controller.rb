class Admin::UsersController < ApplicationController

  def dashboard
    @user = current_user || User.new
  end

  def index
    @users = User.all
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      redirect_to admin_users_path
    else
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :cohort)
  end

end

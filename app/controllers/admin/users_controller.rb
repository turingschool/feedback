class Admin::UsersController < ApplicationController

  def index
    @user ||= User.new
    @users  = User.all
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      redirect_to admin_users_path
    else
      redirect_to admin_users_path
    end
  end

  def create
    user = User.create(user_params)
    if user.save
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :cohort)
  end
end

class Admin::UsersController < Admin::BaseAdminController

  def index
    @user   ||= User.new
    @users  ||= User.all
    @password = SecureRandom.base64
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      flash[:success] = "User Updated"
      redirect_to admin_users_path
    else
      flash[:success] = "Unable to update User"
      redirect_to admin_users_path
    end
  end

  def create
    user = User.create(user_params)
    if user.save
      flash[:success] = "User Created"
      redirect_to admin_users_path
    end
  end

  def deliver_all
    user       = User.find(params[:id])
    submission = Submission.where(feedback_for_id: user.id).constructive
    if submission.present?
      send_all_contructive_submissions_to_user(user.id)
      flash[:success] = "All Eligible Submissions Sent"
      redirect_to admin_users_path
    else
      flash[:error] = "No Eligible Submissions"
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :cohort, :password, :password_confirmation)
  end
end

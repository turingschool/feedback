class Admin::UsersController < Admin::BaseAdminController

  def index
    @user   ||= User.new
    @users  ||= User.all.order('cohort')
    @password = SecureRandom.base64
  end

  def new #Cohort
    if params[:students_list]
      students_list = params[:students_list]
      cohort      ||= params[:cohort]
      if create_students(students_list, cohort)
        flash[:success] = "New Cohort Created"
        redirect_to admin_users_path
      else
        flash[:error] = "Unable to create new cohort"
        redirect_to admin_new_users_path
      end
    end
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      flash[:success] = "User Updated"
      redirect_to admin_users_path
    else
      flash[:error] = "Unable to update User"
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted"
    redirect_to admin_users_path
  end

  def deliver_all
    submissions = get_submissions_for_user(User.find(params[:id]))

    if submission.empty?
      flash[:error] = "No eligible submissions to send"
      redirect_to admin_users_path
    else
      send_all_contructive_submissions_to_user(submissions)
      flash[:success] = "All Eligible Submissions Sent"
      redirect_to admin_users_path
    end
  end

  private

  def get_submissions_for_user(user)
    Submission.joins(:invite).where("invites.feedback_for" => user, peer_review_score: 2)
  end

  def user_params
    params.require(:user).permit(:email, :name, :cohort, :password, :password_confirmation)
  end

  def create_students(student_list, cohort)
    students = split_cohort(student_list)
    students.each do |student|
      User.create!(cohort: cohort,
                   name: student[:name],
                   email: student[:email],
                   password: SecureRandom.base64)
    end
  end

  def split_cohort(list)
    lines = list.split(',')
    lines.map do |line|
      info = line.split("<").map{|x|x.gsub(/"|\/|>/, '').strip}
      {name: info[0], email: info[1]}
    end
  end

  def send_all_contructive_submissions_to_user(submissions)
    submissions.each do |sub|
      SubmissionMailer.send_submission(sub).deliver_now
    end
  end
end

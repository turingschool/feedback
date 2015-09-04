class Admin::SubmissionsController < ApplicationController

  def positive
    sub = Submission.find(params[:id])
    if sub.update_attributes(peer_review_score: sub.peer_review_score+1)
      # sub.peer_review_score == 2 ? send_submission_email(sub) : false
      redirect_to admin_submissions_path
    end
  end

  def negative
    sub = Submission.find(params[:id])
    if sub.update_attributes(peer_review_score: sub.peer_review_score-1)
      sub.peer_review_score == -2 ? send_to_bad_review : false
      redirect_to admin_submissions_path
    end
  end

  def update
    invite = Submission.find(params[:id])
    if invite.update_attributes(submission_params)
      flash[:success] = "Submission Updated"
      redirect_to admin_submissions_path
    else
      flash[:error] = "Could not update submission"
      redirect_to admin_submissions_path
    end
  end

  def index
    all = Submission.all
    @good_submissions  = all.where(peer_review_score: 2)
    @bad_submissions   = all.where(peer_review_score: -2)
    @limbo_submissions = all.where(peer_review_score: -1..1)
  end

  private

  # def send_submission_email(submission)
  #   user = User.find(submission.feedback_for_id)
  #   SubmissionMailer.send_submission(submission, user).deliver_now
  # end

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end

end

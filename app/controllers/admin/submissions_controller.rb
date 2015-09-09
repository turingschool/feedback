class Admin::SubmissionsController < ApplicationController

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

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end
end

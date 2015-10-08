class Admin::SubmissionsController < Admin::BaseAdminController

  def update
    submission = Submission.find(params[:id])
    score = submission.peer_review_score
    if submission.update_attributes(peer_review_score: [score,1].inject(params[:type].to_sym))
      flash[:success] = "Review Score updated"
      redirect_to admin_submissions_path
    else
      flash[:error] = "Unable to update submission score"
      redirect_to admin_submissions_path
    end
  end

  def index
    all = Submission.all
    @good_submissions  = all.constructive
    @bad_submissions   = all.not_constructive
    @limbo_submissions = all.where(peer_review_score: -1..1)
  end

  private

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end
end

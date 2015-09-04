class SubmissionsController < ApplicationController

  def new
    @invite = Invite.find_by(token: params[:token])
    @submission = @invite.submissions.new(:feedback_for => @invite.feedback_for,
                                          :feedback_from => @invite.feedback_from,
                                          :token => params[:token ])
  end

  def create
    binding.pry
    @invite = Invite.find(params[:submission][:invite_id])
    @submission = @invite.submissions.new(
      :feedback_for_id => @invite.feedback_for_id,
      :feedback_from_id => @invite.feedback_from_id,
      :comments      => params[:submission][:comments],
      :participation => params[:submission][:participation],
      :valuable      => params[:submission][:valuable],
      :again         => params[:submission][:again]
    )
    if @submission.save
      @invite.completed!
      redirect_to submissions_path(uid: params[:submission][:user_id])
    else
      render :new
    end
  end

  def positive
    binding.pry
    sub = Submission.find(params[:id])
    if sub.update_attributes(peer_review_score: sub.peer_review_score+1)
      update_user_peer_review_count(params[:uid])
      redirect_to submissions_path(uid: params[:uid])
    end
  end

  def negative
    sub = Submission.find(params[:id])
    if sub.update_attributes(peer_review_score: sub.peer_review_score-1)
      update_user_peer_review_count(params[:uid])
      redirect_to submissions_path(uid: params[:uid])
    end
  end

  def update
    invite = Submission.find(params[:id])
    if invite.update_attributes(submission_params)
      flash[:success] = "Submission Updated"
      redirect_to submissions_path
    else
      flash[:error] = "Could not update submission"
      redirect_to submissions_path
    end
  end

  def index
    @user = User.find(params[:uid])
    @submissions = Submission.where({ peer_review_score: -1..1 }).limit(3)
  end

  private

  def update_user_peer_review_count(id)
    binding.pry
    user = User.find(id)
    user.update_attributes(peer_review_count: user.peer_review_count+1)
    user.check_review_count
  end

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end

end

class SubmissionsController < ApplicationController

  def new
    @invite = Invite.find_by(token: params[:token])
    @submission = @invite.submissions.new(:feedback_for => @invite.feedback_for,
                                          :feedback_from => @invite.feedback_from,
                                          :token => params[:token ])
  end

  def create
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
    update_peer_review_score(params[:uid],'+')
  end

  def negative
    update_peer_review_score(params[:uid],'-')
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
    @reviews_needed = get_review_needed_count(params[:uid])
    @submissions   = Submission.where({ peer_review_score: -1..1 })
  end

  private

  def update_peer_review_score(user_id, type)
    sub   = Submission.find(params[:id])
    score = sub.peer_review_score
    if sub.update_attributes(peer_review_score: [score,1].inject(type.to_sym) )
      update_user_peer_review_count(user_id)
      redirect_to submissions_path(uid: user_id)
    end
  end

  def get_review_needed_count(user_id)
    user  = User.find(user_id)
    group = user.invites.last.invite_set.groups.lines.first
    member_count = find_other_group_members(user, group)
  end

  def find_other_group_members(user, group)
    (group.split(likely_separators(group)).count - 1) * 3
  end

  def likely_separators(group)
    if group.include?(",")
      ","
    else
      "&"
    end
  end

  def update_user_peer_review_count(id)
    user = User.find(id)
    user.update_attributes(peer_review_count: user.peer_review_count+1)
  end

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end

end

class SubmissionsController < ApplicationController

  def new
    @invite = Invite.find_by(token: params[:token])
    @submission = @invite.submissions.new(:feedback_for => @invite.feedback_for,
                                          :feedback_from => @invite.feedback_from,
                                          :token => params[:token ])
    if cookies[:feedback_user].nil?
      cookies.signed[:feedback_user] = { value: @invite.feedback_from, expires: 2.days.from_now }
    end
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
      redirect_to submissions_path
    else
      render :new
    end
  end

  def positive
    update_peer_review_score('+')
  end

  def negative
    update_peer_review_score('-')
  end

  def index
    @reviews_needed = get_review_needed_count
    @submissions    = Submission.where({ peer_review_score: -1..1 })
  end

  private

  def update_peer_review_score(type)
    sub   = Submission.find(params[:id])
    score = sub.peer_review_score
    if sub.update_attributes(peer_review_score: [score,1].inject(type.to_sym))
      update_current_user_peer_review_count
      redirect_to submissions_path
    end
  end

  def get_review_needed_count
    group = current_user.invites.last.invite_set.groups.lines.first
    find_other_group_members(group)
  end

  def find_other_group_members(group)
    (group.split(likely_separators(group)).count - 1) * 3
  end

  def likely_separators(group)
    if group.include?(",")
      ","
    else
      "&"
    end
  end

  def update_current_user_peer_review_count
    current_user.update_attributes(peer_review_count: current_user.peer_review_count + 1)
  end

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end
end

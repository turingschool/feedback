class SubmissionsController < ApplicationController
  def new
    @invite = Invite.find(params[:invite_id])
    @submission = @invite.submissions.new(:feedback_for => @invite.feedback_for,
                                          :feedback_from => @invite.feedback_from)
  end

  def create
    @invite = Invite.find(params[:submission][:invite_id])
    @submission = @invite.submissions.new(
      :feedback_for_id => @invite.feedback_for_id,
      :feedback_from_id => @invite.feedback_from_id,
      :participation => params[:submission][:particiation],
      :valuable      => params[:submission][:valuable],
      :again         => params[:submission][:again],
      :comments      => params[:submission][:comments]
    )
    @submission.save!
    @invite.completed!
    redirect_to invites_path(:user_id => @invite.feedback_from_id)
  end
end

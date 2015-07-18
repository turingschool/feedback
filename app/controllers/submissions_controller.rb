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
      :comments      => params[:submission][:comments],
      :participation => params[:submission][:participation],
      :valuable      => params[:submission][:valuable],
      :again         => params[:submission][:again]
    )
    if @submission.save
      @invite.completed!
      redirect_to invites_path(:user_id => @invite.feedback_from_id)
    else
      render :new
    end
  end
end

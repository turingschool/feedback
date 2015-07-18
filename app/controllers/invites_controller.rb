class InvitesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @pending_invites = @user.invites.pending
    @completed_invites = @user.invites.completed
  end
end

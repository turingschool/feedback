class InvitesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @invites = @user.invites
  end
end

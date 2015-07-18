class InviteSetsController < ApplicationController
  def new
    @invite_set = InviteSet.new
  end

  def create
    @invite_set = InviteSet.new(
      :title => params[:invite_set][:title],
      :groups => params[:invite_set][:groups]
    )
    if @invite_set.save
      redirect_to invite_sets_path
    end
  end

  def index
    @invite_sets = InviteSet.all
  end

  def deliver
    @invite_set = InviteSet.find(params[:id])
    @invite_set.deliver!
    redirect_to invite_sets_path
  end

end

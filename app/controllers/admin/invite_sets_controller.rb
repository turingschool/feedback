class Admin::InviteSetsController < ApplicationController
  def new
    @invite_set ||= InviteSet.new
  end

  def create
    @invite_set = InviteSet.new(
      :title => params[:invite_set][:title],
      :groups => params[:invite_set][:groups]
    )
    if @invite_set.save
      redirect_to admin_invite_sets_path
    end
  end

  def show
    @invite_set = InviteSet.find(params[:id])
  end

  def index
    @invite_sets = InviteSet.all
  end

  def deliver
    @invite_set = InviteSet.find(params[:id])
    @invite_set.deliver!
    redirect_to admin_invite_sets_path
  end
end

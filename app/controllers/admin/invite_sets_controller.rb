class Admin::InviteSetsController < Admin::BaseAdminController

  def new
    @invite_set ||= InviteSet.new
  end

  def create
    @invite_set = InviteSet.new(
      :title => params[:invite_set][:title],
      :groups => params[:invite_set][:groups]
    )
    if @invite_set.save
      flash[:success] = "Invite Set Created"
      redirect_to admin_invite_sets_path
    end
  end

  def show
    @invite_set = InviteSet.find(params[:id])
  end

  def index
    @invite_sets = InviteSet.all
  end

  def destroy
    set = InviteSet.find(params[:id])
    if set.destroy
      flash[:success] = "Project has been deleted"
      redirect_to admin_invite_sets_path
    else
      flash[:error] = "Could not delete Project"
      redirect_to admin_invite_sets_path
    end
  end

  def deliver
    @invite_set = InviteSet.find(params[:id])
    @invite_set.deliver!
    flash[:success] = "Invites Delivered"
    redirect_to admin_invite_sets_path
  end
end

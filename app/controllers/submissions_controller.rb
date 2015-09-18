class SubmissionsController < ApplicationController

  def new
    @invite = Invite.find_by(token: params[:token])
    if @invite.nil?
      flash[:error] = "That invitation no longer exsists."
      redirect_to root_path
    else
      @submission = @invite.submissions.new(:feedback_for => @invite.feedback_for,
                                            :feedback_from => @invite.feedback_from,
                                            :token => params[:token ])
      check_cookies
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
      flash[:success] = "Thanks for leaving feedback, Check below to see if you need to review any other feedback"
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
    if cookies[:feedback_user]
      @reviews_needed = get_reviews_needed_count
      @submissions    = Submission.where({ peer_review_score: -1..1 }).where.not({ feedback_from_id: current_user.id })
    else
      render file: "public/401.html"
    end
  end

  private

  def update_peer_review_score(type)
    sub   = Submission.find(params[:id])
    score = sub.peer_review_score
    if sub.update_attributes(peer_review_score: [score,1].inject(type.to_sym))
      update_current_user_peer_review_count
      flash[:success] = "Review Score updated"
      redirect_to submissions_path
    end
  end

  def check_cookies
    if cookies[:feedback_user].nil?
      cookies.signed[:feedback_user] = { value: @invite.feedback_from, expires: 2.days.from_now }
    end
  end

  def get_reviews_needed_count
    Submission.where( feedback_for_id: current_user.id ).not_sent.count * 3
  end

  def update_current_user_peer_review_count
    current_user.update_attributes(peer_review_count: current_user.peer_review_count + 1)
  end

  def submission_params
    params.require(:submission).permit(:peer_review_score)
  end
end

class User < ActiveRecord::Base
  has_many :invites, :foreign_key => :feedback_from_id, dependent: :destroy
  has_many :submissions, through: :invites
  # after_save :check_peer_review_count


  def check_peer_review_count
    if peer_review_count >= 3
      send_user_one_submission_email
    end
  end

  def send_submission_email(submission)
    SubmissionMailer.send_submission(submission).deliver_now
    submission.delivered!
    reset_peer_review_count
    calculate_delivery_percent(submission.feedback_from.id)
  end

  def undelivered_ready_submission(user)
    Submission.find { |x| x.invite.feedback_for == user  &&
                      x.peer_review_score   == 2     &&
                      x.delivered           == false }
  end

  private

  def send_user_one_submission_email
    submission  = undelivered_ready_submission(self)
    if submission.present?
      send_submission_email(submission)
    end
  end

  def reset_peer_review_count
    self.peer_review_count = self.peer_review_count - 3
    self.save!
  end

  def calculate_delivery_percent(user_from_id)
    user  = User.find(user_from_id)
    all   = user.submissions
    total = all.count
    sent  = all.where(peer_review_score: 2).count
    user.delivery_percentage = (sent).to_f/(total).to_f*100
    user.save!
  end
end

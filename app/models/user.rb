class User < ActiveRecord::Base
  # validates :email, uniqueness: true
  has_many :invites, :foreign_key => :feedback_from_id
  before_save :check_peer_review_count

  def check_peer_review_count
    if peer_review_count >= 3
      send_submission_email ? reset_peer_review_count : true
    end
  end

  private

  def send_submission_email
    submission = Submission.where(feedback_for_id: self.id).where(peer_review_score: 2).limit(1).first
    if submission.present?
      SubmissionMailer.send_submission(submission, self).deliver_now
      calculate_delivery_percent(submission.feedback_from_id)
    end
  end

  def reset_peer_review_count
    self.peer_review_count = 0
    self.save!
  end

  def calculate_delivery_percent(id) #Not necessarlily delivered, but are all elegable for deilvery.
    user  = User.find(id)
    all   = Submission.where(feedback_from_id: id)
    total = all.count
    sent  = all.where(peer_review_score: 2).count
    user.delivery_percentage = (sent).to_f/(total).to_f*100
    user.save!
  end
end

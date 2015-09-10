class User < ActiveRecord::Base
  # validates :email, uniqueness: true
  has_many :invites, :foreign_key => :feedback_from_id
  after_save :check_peer_review_count


  def check_peer_review_count
    if peer_review_count >= 3
      send_submission_email ? reset_peer_review_count : true
    end
  end

  def send_submission_email
    submission = Submission.where(feedback_for_id: self.id).constructive.first
    if submission.present?
      title = submission.project_title
      SubmissionMailer.send_submission(submission, self, title).deliver_now
      calculate_delivery_percent(submission.feedback_from_id)
    end
  end

  private

  def reset_peer_review_count
    peer_review_count = peer_review_count - 3
    self.save!
  end

  def calculate_delivery_percent(user_from_id) #Not necessarlily delivered, but are all elegable for deilvery.
    user  = User.find(user_from_id)
    all   = Submission.where(feedback_from_id: id)
    total = all.count
    sent  = all.where(peer_review_score: 2).count
    user.delivery_percentage = (sent).to_f/(total).to_f*100
    user.save!
  end
end

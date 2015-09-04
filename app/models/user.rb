class User < ActiveRecord::Base
  # validates :email, uniqueness: true
  has_many :invites, :foreign_key => :feedback_from_id


  def check_review_count
    self.peer_review_count >= 3 ? send_submission_email : false
  end

  private

  def send_submission_email
    submission = Submission.where(feedback_for_id: self.id).where(peer_review_score: 2).limit(1).first
    if SubmissionMailer.send_submission(submission, self).deliver_now
      self.peer_review_count = 0
      self.save!
      calculate_delivery_percent(submission.feedback_from_id)
      binding.pry
    end
  end

  def calculate_delivery_percent(id)
    all   = Submission.where(feedback_from_id: id)
    total = all.count
    sent  = all.where(peer_review_score: 2).count
    User.find(id).delivery_percentage = (sent).to_f/(total).to_f*100
  end
end

class User < ActiveRecord::Base
  has_secure_password
  validates :password, confirmation: true
  # validates :email, uniqueness: true
  has_many :invites, :foreign_key => :feedback_from_id, dependent: :destroy
  has_many :submissions, through: :invites
  after_save :check_peer_review_count

  def check_peer_review_count
    if peer_review_count >= 3
      send_submission_email
    end
  end

  def send_submission_email
    submission = submissions.not_sent.constructive.first
    if submission.present?
      title = submission.project_title
      SubmissionMailer.send_submission(submission, self, title).deliver_now
      submission.delivered!
      reset_peer_review_count
      calculate_delivery_percent(submission.feedback_from.id)
    end
  end

  private

  def reset_peer_review_count
    self.peer_review_count = self.peer_review_count - 3
    self.save!
  end

  def calculate_delivery_percent(user_from_id) #Not necessarlily delivered, but are all elegile for deilvery.
    user  = User.find(user_from_id)
    all   = user.submissions
    total = all.count
    sent  = all.where(peer_review_score: 2).count
    user.delivery_percentage = (sent).to_f/(total).to_f*100
    user.save!
  end
end

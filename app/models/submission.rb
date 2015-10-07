class Submission < ActiveRecord::Base
  belongs_to :invite
  has_one :feedback_from, through: :invite
  has_one :feedback_for,  through: :invite
  validates_presence_of :participation
  validates_presence_of :valuable
  validates_presence_of :again
  validates :comments, :length => {in: 10..240}
  validates :peer_review_score, :inclusion => {in: -2..2}
  scope :not_sent,         ->{ where(delivered: false) }
  scope :constructive,     ->{ where(peer_review_score: 2) }
  scope :not_constructive, ->{ where(peer_review_score: -2) }
  after_save :check_to_send


  def project_title
    invite.invite_set.title
  end

  def self.options
    [
      :strongly_disagree,
      :disagree,
      :neutral,
      :agree,
      :strongly_agree
    ]
  end

  def word_to_score(word)
    {
      'strongly_disagree' => -2,
      'disagree'          => -1,
      'neutral'           =>  0,
      'agree'             =>  1,
      'strongly_agree'    =>  2
    }[word]
  end

  private

  def check_to_send
    if peer_review_score == 2
      check_user_score_count(feedback_for.id)
    end
  end

  def check_user_score_count(uid)
    user = User.find(uid)
    if user.peer_review_count >= 3
      user.send_submission_email
    end
  end
end

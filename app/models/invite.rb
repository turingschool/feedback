class Invite < ActiveRecord::Base
  belongs_to :invite_set
  belongs_to :feedback_from, :class_name => User
  belongs_to :feedback_for, :class_name => User
  has_many   :submissions
  before_save :generate_token

  def self.pending
    where(:completed => false)
  end

  def self.completed
    where(:completed => true)
  end

  def completed!
    self.completed = true
    self.save!
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end

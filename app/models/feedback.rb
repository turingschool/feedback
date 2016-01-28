class Feedback < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  before_create :assign_token

  def self.pending
    where(text: nil)
  end

  def self.submitted
    where.not(text: nil)
  end

  def assign_token
    self.token = SecureRandom.hex(14)
  end

  def to_param
    token
  end
end

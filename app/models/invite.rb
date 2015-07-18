class Invite < ActiveRecord::Base
  belongs_to :invite_set
  belongs_to :feedback_from, :class_name => User
  belongs_to :feedback_for, :class_name => User
  has_many   :submissions

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
end

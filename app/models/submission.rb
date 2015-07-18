class Submission < ActiveRecord::Base
  belongs_to :invite
  belongs_to :feedback_from, :class_name => User
  belongs_to :feedback_for, :class_name => User
end

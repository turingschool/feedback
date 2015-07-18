class Invite < ActiveRecord::Base
  belongs_to :invite_set
  belongs_to :feedback_from, :class_name => User
  belongs_to :feedback_for, :class_name => User
end

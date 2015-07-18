class User < ActiveRecord::Base
  has_many :invites, :foreign_key => :feedback_from_id
end

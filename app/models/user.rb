class User < ActiveRecord::Base
  has_many :sent_feedback, class_name: "Feedback", foreign_key: :sender_id
  has_many :received_feedback, class_name: "Feedback", foreign_key: :receiver_id
end

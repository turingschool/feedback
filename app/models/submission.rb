class Submission < ActiveRecord::Base
  belongs_to :invite
  belongs_to :feedback_from, :class_name => User
  belongs_to :feedback_for, :class_name => User

  validates_presence_of :participation
  validates_presence_of :valuable
  validates_presence_of :again
  validates :comments, :length => {in: 10..240}

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
end

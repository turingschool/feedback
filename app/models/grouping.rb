class Grouping < ActiveRecord::Base
  before_create :assign_tag

  def assign_tag
    self.tag = FriendlyTag.generate
  end

  def groups
    content.gsub("* ","").split("\n").map { |g| g.split(", ") }
  end

  def to_param
    tag
  end
end

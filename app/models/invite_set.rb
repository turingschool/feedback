class InviteSet < ActiveRecord::Base
  has_many :invites

  def deliver!
    parsed_groups.each do |group|
      cross_invite(group)
    end
    self.delivered = true
    self.save!
  end

  def group_count
    groups.lines.count
  end

  def parsed_groups
    groups.each_line.map do |group|
      members_from(group)
    end
  end

  def members_from(group)
    raw_members = strip_list_marker(group)
    likely_separator = likely_separator(raw_members)
    names = raw_members.split(likely_separator).map{|m| m.strip}
    names.map{|n| User.find_by_name(n)}
  end

  def cross_invite(group)
    group.each do |target|
      others = group - [target]
      others.each do |other|
        invites.create!(:feedback_from => target, :feedback_for => other)
      end
    end
  end

  def strip_list_marker(group)
    group[group.index(/\w/)..-1]
  end

  def likely_separator(group)
    if group.include?(",")
      ","
    else
      "&"
    end
  end
end

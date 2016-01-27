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

  def member_names(group)
    raw_members = strip_list_marker(group)
    likely_separator = likely_separator(raw_members)
    names = raw_members.split(likely_separator).map{|m| m.strip}
  end

  def members_from(group)
    member_names(group).map do |n|
      user = User.find_by_name(n)
      if user.nil?
        raise "Validation Error. There's something wrong with the users entered. Check the user names again"
      else
        user
      end
    end
  end

  def cross_invite(group)
    group.each do |target|
      others = group - [target]
      others.each do |other|
        invites.create!(:feedback_from => target, :feedback_for => other)
        InviteMailer.create_invite(User.find(target.id), User.find(other.id), Invite.last.token).deliver_now
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

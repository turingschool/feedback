  require 'test_helper'

class InviteSetTest < ActiveSupport::TestCase

  def test_it_marks_delivered_invite_sets
    set = make_invite_set
    refute set.delivered?
    set.deliver!
    assert set.delivered?
  end

  def test_it_delivers_individual_invites
    set = make_invite_set
    assert_equal 2, set.group_count
    set.deliver!
    assert_equal 4, set.invites.count
    set.invites.each do |invite|
      refute invite.completed?
    end
  end

  def test_it_finds_members_in_a_group
    user1 = User.create(name: "Steve Kinney")
    user2 = User.create(name: "Jeff Casimir")
    set = InviteSet.new
    members = set.members_from("* Steve Kinney & Jeff Casimir")
    assert_equal 2, members.count
    assert_includes members, user1
    assert_includes members, user2
  end
end

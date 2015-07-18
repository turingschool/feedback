require 'test_helper'

class InviteSetTest < ActiveSupport::TestCase

  def test_it_marks_delivered_invite_sets
    set = make_invite_set
    refute set.delivered?
    set.deliver!
    assert set.delivered?
  end
end

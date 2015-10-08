require "rails_helper"

RSpec.describe InviteSet, type: :model do

  def make_invite_set
    User.create(name: "Steve Kinney", password: "aaa", email: "st@email.completed")
    User.create(name: "Jeff Casimir", password: "aaa", email: "j@email.completed")
    User.create(name: "Rachel Warbelow", password: "aaa", email: "r@email.completed")
    User.create(name: "Jorge Tellez", password: "aaa", email: "jorg@email.completed")

    InviteSet.create!(
      'title' => "Sample Project A",
      'groups' => "* Jeff Casimir & Rachel Warbelow\n* Steve Kinney & Jorge Tellez"
    )
  end

  describe "deliver!" do
    it "marks invited sets delived" do
      set = make_invite_set
      expect(set.delivered?).to be(false)
      set.deliver!
      expect(set.delivered?).to be(true)
    end

    it "delivers individual invites" do
      set = make_invite_set
      expect(set.group_count).to eq(2)
      set.deliver!
      expect(set.invites.count).to eq(4)
      set.invites.each do |invite|
        expect(invite.completed?).to be(false)
      end
    end

    it "finds memebers group members" do
      user1 = User.create(name: "Steve Kinney", password: "aaa", email: "st@email.completed")
      user2 = User.create(name: "Jeff Casimir", password: "aaa", email: "j@email.completed")
      set = InviteSet.new
      members = set.members_from("* Steve Kinney & Jeff Casimir")
      expect(members.count).to eq(2)
      expect(members).to include(user1)
      expect(members).to include(user2)
    end
  end
end

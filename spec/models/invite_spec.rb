require "rails_helper"

RSpec.describe Invite, type: :model do

  # let(:submission) { User.create(name: "Nike Nee", email: "nike@example.com", password: "password") }
  let(:invite1) { Invite.create!(completed: true) }
  let(:invite2) { Invite.create!(completed: false) }
  let(:invite3) { Invite.create!(completed: false) }
  let(:invite4) { Invite.create!(completed: false) }

  describe "Pending" do
    it "will return all of the pending invites" do
      invite1
      invite2
      invite3
      invite4
      expect(Invite.pending).to_not be_empty
      expect(Invite.pending.count).to be(3)
    end
  end

  describe "Completed" do
    it "will return all of the comppleted invites" do
      invite1
      invite2
      invite3
      invite4
      expect(Invite.completed).to_not be_empty
      expect(Invite.completed.count).to be(1)

    end
  end

  describe "completed!" do
    it "will set completed to true when called" do
      expect(invite2.completed).to eq(false)
      invite2.completed!
      expect(invite1.completed).to eq(true)
    end
  end
end
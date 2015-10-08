require "rails_helper"

RSpec.describe User, type: :model do

  let(:user1) { User.create(name: "Nike Nee", email: "nike@example.com", password: "password") }
  let(:user2) { User.create(name: "Tom Nee", email: "nike@example.com", admin: true, password: "password") }

  describe "admin check" do
    it "returns false if user is not admin" do
      expect(user1.admin?).to be(false)
    end

    it "returns true if user is admin" do
      expect(user2.admin?).to be(true)
    end
  end

  describe "peer review count check" do
    it "will try to send email if user has review count of 3" do
      user1.peer_review_count = 5
      expect(user1).to receive(:send_submission_email)
      user1.save!
    end

    it "will not try to send email if user review count is not >= 3" do
      user1.peer_review_count = 2
      expect(user1).to_not receive(:send_submission_email)
      user1.save!
    end
  end

  describe "calculate delivery percentage" do
    it "returns eliable-to-send submissions / total submissions" do
      user = User.new
      user.send(:calculate_delivery_percent, user1.id)
      expect(user.delivery_percentage).to eq(0)
    end
  end

  describe "reset peer review count" do
    it "subtracts 3 from current count if called" do
      user1.peer_review_count = 5
      user1.save!
      user1.send(:reset_peer_review_count)
      expect(user1.peer_review_count).to eq(2)
    end
  end
end

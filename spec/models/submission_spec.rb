require "rails_helper"

RSpec.describe Submission, type: :model do

  # let(:submission) { User.create(name: "Nike Nee", email: "nike@example.com", password: "password") }

  let(:invite_set) { InviteSet.create(title: "Code Stuff", groups: "tim & mike")}
  let(:user) { User.create(name: "Nike Nee", email: "nike@example.com", password: "password") }
  let(:submission) { submission = invite_set.invites.new.build_submission(participation: 1, valuable: 1, again: 1, comments: "this is the comment", feedback_for: user ) }


  describe "Project title" do
    it "returns project title of invite set for submission" do
      submission = invite_set.invites.new.build_submission()
      expect(submission.project_title).to eq("Code Stuff")
    end
  end

  describe "checks if eliable to send after save" do
    it "will check user user review count if peer score is 2" do
      submission.peer_review_score = 2
      submission.save!
      expect(submisison.send(check_to_send)).to be(true)
    end

    xit "will not check user review count if its score is not 2" do

    end
  end

  describe "check user score count" do
    xit "will try to send submission if user review count is >= 3" do

    end

    xit "will not try to send a submission if user review count if less than 3" do

    end
  end

end

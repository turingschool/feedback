require "rails_helper"

RSpec.describe SubmissionMailer, type: :mailer do
    let(:from) { User.create(name: "Horace", email: "horace@example.com") }
    let(:to) { User.create(name: "Jeff", email: "jeff@example.com") }
    let(:invite_set) { InviteSet.create(title: "Code Retreat Pairing",
                                        groups: "* horace, jeff") }

    let(:invite) { Invite.create(invite_set: invite_set,
                                 feedback_from: from,
                                 feedback_for: to) }

    let(:submission) { Submission.create(invite: invite,
                                         feedback_for: to,
                                         feedback_from: from,
                                         comments: "you da man") }

    before(:each) do
      @email = SubmissionMailer.send_submission(submission).deliver_now
    end

    it "sends a welcome email" do
      expect(@email.body).to have_content(to.name)
    end

    it "renders the headers" do
      expect(@email.content_type).to start_with('text/html; charset=UTF-8')
    end

    it "sets the correct subject" do
      expect(@email.subject).to eq("Code Retreat Pairing FeedBack")
    end
end

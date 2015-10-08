require "rails_helper"

RSpec.describe SubmissionMailer, type: :mailer do
    let(:user) { User.create(name: "Tim Mee", email: "tim@example.com") }
    let(:submission) { Submission.create(feedback_for: user, comments: "you are a good leader") }

    let(:full_subject) { "New Project" }

    before(:each) do
      @email = SubmissionMailer.send_submission(submission, user, full_subject).deliver_now
    end

    it "sends a welcome email" do
      expect(@email.body).to have_content(user.name)
    end

    it "renders the headers" do
      expect(@email.content_type).to start_with('text/html; charset=UTF-8')
    end

    it "sets the correct subject" do
      expect(@email.subject).to eq("#{full_subject} FeedBack")
    end
end

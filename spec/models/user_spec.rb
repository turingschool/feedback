require "rails_helper"

RSpec.describe User, type: :model do
  let(:user_from) { User.create(name: "Tim Mee", email: "tim@example.com") }
  let(:user_to) { User.create(name: "John Nee", email: "john@example.com") }

  let(:full_subject) { "FeedBack Requested" }

  before(:each) do
    @email = InviteMailer.create_invite(user_from, user_to, "238b282836g76").deliver_now
  end

  it "sends a welcome email" do
    expect(@email.body).to have_content(user_from.name)
  end

  it "renders the headers" do
    expect(@email.content_type).to start_with('text/html; charset=UTF-8')
  end

  it "sets the correct subject" do
    expect(@email.subject).to eq(full_subject)
  end
end

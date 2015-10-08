require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe "#create" do
    context "with valid credentials" do
      let :credentials do
        { :email => 'admin@gmail.com', :password => 'password' }
      end

      let :user do
        User.create(email: "admin@gmail.com", :password => 'password', admin: true)
      end

      before :each do
        user
        post :create, credentials
      end

      it "creates a user session" do
        cookies.signed[:feedback_user].should == user.id
      end
    end

    context "with invalid credentials" do
      let :bad_credentials do
        { :email => 'admin@gmail.com', :password => 'notright' }
      end

      let :user do
        User.create(email: "admin@gmail.com", :password => 'password', admin: true)
      end

      before :each do
        user
        post :create, bad_credentials
      end

      it "creates a user session" do
        cookies.signed[:feedback_user].should  be_nil
      end
    end
  end

  describe "#destroy" do
    let :credentials do
      { :email => 'admin@gmail.com', :password => 'password' }
    end

    let :user do
      User.create(email: "admin@gmail.com", :password => 'password', admin: true)
    end

    before :each do
      user
      post :create, credentials
    end

    it "should clear the session" do
      cookies[:feedback_user].should_not be_nil
      delete :destroy
      cookies[:feedback_user].should be_nil
    end

    it "should redirect to the search page" do
      delete :destroy
      response.should redirect_to root_path
    end
  end
end

require 'spec_helper'

describe SessionsController do
  controller_actions = controller_actions("sessions")

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      it "should not reach the #{action} page" do
        send(req, action)
        response.redirect_url.should_not eq login_url 
      end
    end
  end

  context "a user is logged in as" do
    describe "member" do
      before(:each) do
        session[:userid] = create_member.id
      end

      controller_actions.each do |action,req|
        it "should reach the #{action} page" do
          send(req, action)
          response.redirect_url.should_not eq welcome_url
        end
      end
    end 
  end
end

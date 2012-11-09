require 'spec_helper'

describe UsersController do
  controller_actions = controller_actions("users")

  before(:each) do
    @model = FactoryGirl.create(:user)
  end

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      it "should not reach the #{action} page" do
        send("#{req}", "#{action}", :id => @model.id)
        response.redirect_url.should eq login_url 
      end
    end
  end

  context "a user is logged in as" do
    describe "member" do
      let(:own){ create_member }
      before(:each) do
        session[:userid] = own.id 
      end

      controller_actions.each do |action,req|
        if %(edit update).include?(action) 
          it "should not reach other user's #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should eq welcome_url
          end
          it "should reach own's #{action} page"
          #do
          #  send(req, action, :id => own.id, user:{name:'whatever'})
          #  response.redirect_url.should_not eq welcome_url
          #end
        else
          it "should reach the #{action} page" do
            send(req, action, :id => @model.id)
            response.redirect_url.should_not eq welcome_url
          end
        end
      end
    end 
  end
end

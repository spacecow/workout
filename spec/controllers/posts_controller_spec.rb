require 'spec_helper'

describe PostsController do
  controller_actions = controller_actions("posts")

  before(:each) do
    @model = create_post
  end

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      if action == 'index'
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should_not eq login_url 
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}", :id => @model.id)
          response.redirect_url.should eq login_url 
        end
      end
    end
  end

  context "a user is logged in as" do
    describe "member" do
      before(:each) do
        session[:userid] = create_member.id
        @date = '2012-8-23'
        session[:day] = FactoryGirl.create(:day, date:@date).date
        session[:date] = @date
        request.env['HTTP_REFERER'] = posts_path
      end

      controller_actions.each do |action,req|
        it "should reach the #{action} page" do
          send(req, action, id:@model.id)
          response.redirect_url.should_not eq welcome_url
        end
      end
    end 
  end

  describe "delete a post" do
    let(:member){ create :user }

    before do
      session[:userid] = member.id
      request.env["HTTP_REFERER"] = root_path
    end
      
    describe "#destroy" do
      before do
        create :comment, commentable:@model
        delete :destroy, id:@model.id 
      end

      context Post do
        subject{ Post }
        its(:count){ should eq 0 }
      end

      context Comment do
        subject{ Comment }
        its(:count){ should eq 1 }
      end

      context Notification do
        subject{ Notification }
        its(:count){ should eq 1 }
      end

      context 'last comment' do
        subject{ Comment.last }
        its(:deleted_at){ should_not be_nil }
      end
    end #delete a post
  end
end

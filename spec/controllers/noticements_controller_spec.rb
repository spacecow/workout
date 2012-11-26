require 'spec_helper'

describe NoticementsController do
  let(:user){ create :user }
  let(:notification){ create :notification }
  before{ notification.users << user }

  context "#read" do
    before do
      session[:userid] = user.id
      put :read, id:Noticement.last
    end

    context "saved noticement" do
      subject{ Noticement.last }
      it{ should_not be_unread }
    end

    context "response" do
      subject{ response }
      its(:redirect_url){ should eq day_url(Noticement.last.full_date)}
    end
  end
end
  #describe "a user is not logged in" do
  #  controller_actions.each do |action,req|
  #    if action == 'index'
  #      it "should reach the #{action} page" do
  #        send("#{req}", "#{action}", :id => @model.id)
  #        response.redirect_url.should_not eq login_url 
  #      end
  #    else

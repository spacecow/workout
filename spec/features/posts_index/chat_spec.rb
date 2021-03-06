require 'spec_helper'

describe "Posts index, chat" do
  before(:each) do
    login
    FactoryGirl.create(:comment, content:'Oh yeah!', commentable:create_post(date:'2012-09-20'))
    visit posts_path(month:'2012/8')
  end

  it "shows no delete link" do
    chat.should_not have_link 'Delete'
  end
end 

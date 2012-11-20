require 'spec_helper'

describe "Posts index, chat" do
  before(:each) do
    login
    FactoryGirl.create(:comment, content:'Oh yeah!', commentable:create_post(date:'2012-09-20'))
    visit posts_path(month:'2012/8')
  end

  it "has a title" do
    chat.should have_content("Live Update")
  end

  it "shows the comment as a link" do
    chat.should have_link('Oh yeah!')
  end

  it "click comment's content redirects to the day page" do
    chat.click_link 'Oh yeah!'
    current_path.should eq day_path('2012-09-20')
  end

  it "shows no delete link" do
    chat.should_not have_link 'Delete'
  end
end 

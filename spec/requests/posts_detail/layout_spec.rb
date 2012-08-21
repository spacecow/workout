require 'spec_helper'

describe 'Posts detail' do
  context 'without posts' do
    before(:each) do
      login
      visit detail_posts_path(date:'2012-7-5', month:'2012/7')
    end

    it "has a reservation button" do
      page.should have_button('Post')
      click_button 'Post'
      page.current_path.should eq new_post_path
      value('* Date').should eq '2012-07-05'
    end

    it "has a calendar button" do
      page.should have_button('Calendar')
      click_button 'Calendar'
      current_path.should eq posts_path
      page.should have_content('July 2012')
    end
  end

  context 'with posts' do
    before(:each) do
      prince = FactoryGirl.create(:user, userid:'Prince')
      FactoryGirl.create(:post, date:Date.parse('2012-7-10'), author:prince, duration:35, comment:'Just some random comment.')
      login
      visit detail_posts_path(date:'2012-7-5', month:'2012/7')
    end
  end
end

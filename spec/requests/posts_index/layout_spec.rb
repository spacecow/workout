require 'spec_helper'

describe "Posts index" do
  context "without posts" do
    before(:each) do
      visit posts_path(month:'2012/7')
    end

    it "has a month title" do
      h2(:month).should have_content('July 2012')
    end

    it "has a link to the previous month" do
      h2(:month).should have_link('<')
      h2(:month).click_link('<')
      h2(:month).should have_content('June 2012')
    end

    it "has a link to the next month" do
      h2(:month).should have_link('>')
      h2(:month).click_link('>')
      h2(:month).should have_content('August 2012')
    end
  end

  context "logged in user" do
    before(:each) do
      login
      visit posts_path(month:'2012/7')
    end

    it "has links to detail posts" do
      td(:day_0701).click_link('1')
      page.current_path.should eq new_post_path
      page.should have_title('2012-07-01')
    end
  end

  context "non-user" do
    before(:each) do
      visit posts_path(month:'2012/7')
    end

    it "has links to detail posts" do
      td(:day_0701).should_not have_link('1')
    end
  end

  it "with a post with a partner" do
    partner = FactoryGirl.create(:user, userid:'Partner')
    author = FactoryGirl.create(:user, userid:'Author')
    post = FactoryGirl.create(:post, date:Date.parse('2012-7-10'), author:author)
    post.training_partners << partner
    visit posts_path(month:'2012/7')
    td(:day_0710).div(:posts,0).should have_content('Author&Partner: 1')
  end

  context "with posts of different authors" do
    before(:each) do
      prince = FactoryGirl.create(:user, userid:'Prince')
      king = FactoryGirl.create(:user, userid:'King')
      FactoryGirl.create(:post, date:Date.parse('2012-7-10'), author:prince)
      FactoryGirl.create(:post, date:Date.parse('2012-7-10'), author:king)
      visit posts_path(month:'2012/7')
    end

    it "displays existing posts on given day" do
      td(:day_0710).div(:posts,0).should have_content('Prince: 1')
      td(:day_0710).div(:posts,1).should have_content('King: 1')
    end

    it "displays no posts if there are none" do
      td(:day_0709).should_not have_content('0')
    end
  end
end

  #describe "Bookings index" do
  #  context "with booking" do
  #    before(:each) do
  #      FactoryGirl.create(:booking, date:Date.parse('2012-7-2'))
  #    end
  #
  #    it "single" do
  #      visit bookings_path(month:'2012/7')
  #      td(:day_0702).should have_content('Booking: 1')
  #    end
  #
  #    it "double" do
  #      FactoryGirl.create(:booking, date:Date.parse('2012-7-2'))
  #      visit bookings_path(month:'2012/7')
  #      td(:day_0702).should have_content('Bookings: 2')
  #    end
  #  end
  #end

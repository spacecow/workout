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
      page.current_path.should eq day_path('2012-07-01')
      #page.should have_title('2012-07-01')
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
    post = create_post(date:'2012-7-10', author:'Author', partner:'Partner', duration:100)
    visit posts_path(month:'2012/7')
    td(:day_0710).div(:posts,0).should have_content('Author&Partner: 100')
  end

  context "with posts of different authors" do
    before(:each) do
      day = FactoryGirl.create(:day, date:Date.parse('2012-7-10'))
      create_post(day:day, author:'Prince', duration:50)
      create_post(day:day, author:'King', duration:123)
      visit posts_path(month:'2012/7')
    end

    it "displays existing posts on given day", focus:true do
      td(:day_0710).div(:posts,0).should have_content('Prince: 50')
      td(:day_0710).div(:posts,1).should have_content('King: 123')
    end

    it "displays no posts if there are none" do
      td(:day_0709).should_not have_content('0')
    end
  end
end

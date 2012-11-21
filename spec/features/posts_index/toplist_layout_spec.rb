require 'spec_helper'

describe "Posts index, toplist" do
  context "without users" do
    before(:each) do
      visit posts_path(month:'2012/7')
    end

    it "displays no toplists" do
      page.should_not have_div(:menu_toplists)
    end
  end

  context "with users, not logged in" do
    before(:each) do
      create_member(userid:'Prince')
      visit posts_path(month:'2012/7')
    end

    it "displays no toplists" do
      page.should_not have_div(:menu_toplists)
    end
  end

  context "with users, logged in" do
    before(:each) do
      @prince = create_member(userid:'Prince')
      @king = create_member(userid:'King')
      login(@prince)
    end

    #context "without posts" do
    #  before(:each) do
    #    visit posts_path(month:'2012/7')
    #  end

    #  it "displays toplists" do
    #    page.should have_div(:menu_toplists)
    #  end

    #  it "lists each user & total time" do
    #    first_user7.should have_content 'Prince -'
    #    second_user7.should have_content 'King -'
    #  end

    #  context "charts link" do
    #    it "has a link" do
    #      toplists.should have_link 'Charts'
    #    end

    #    it "redirects to the chart page" do
    #      toplists.click_link 'Charts'
    #      current_path.should eq stats_charts_path
    #    end
    #  end
    #end

    #context "with posts, not older than timeframe" do
    #  before(:each) do
    #    create_post(user:@prince, duration:30, date:"#{Date.today - 2.days}")
    #    visit posts_path(month:'2012/7')
    #  end

    #  it "lists each user & total time" do
    #    first_user7.should have_content 'Prince -'
    #  end
    #end

    #context "with posts, within scope" do
    #  before(:each) do
    #    create_post(user:@prince, duration:30, date:"#{Date.today-6.days}")
    #    create_post(user:@king, duration:80, date:"#{Date.today}")
    #    create_post(user:@king, date:"#{Date.today-8.days}")
    #    visit posts_path(month:'2012/7')
    #  end

    #  it "displays toplists" do
    #    page.should have_div(:menu_toplists)
    #  end

    #  it "lists each user & total time" do
    #    first_user7.should have_content 'Prince 30 min'
    #    second_user7.should have_content 'King 80 min'
    #  end
    #end

    #context "with posts, outside scope" do
    #  before(:each) do
    #    create_post(user:@prince, date:"#{Date.today - 8.days}")
    #    create_post(user:@king, date:"#{Date.today + 1.day}")
    #    create_post(user:@king, date:"#{Date.today - 9.day}")
    #    visit posts_path(month:'2012/7')
    #  end

    #  it "lists each user & total time" do
    #    first_user7.should have_content 'Prince 0 min'
    #    second_user7.should have_content 'King 0 min'
    #  end
    #end

    #context "with posts as partner" do
    #  before(:each) do
    #    create_post(user:@prince, date:"#{Date.today-8.days}", user_partner:@king)
    #    create_post(user:@prince, duration:30, date:"#{Date.yesterday}", user_partner:@king)
    #    visit posts_path(month:'2012/7')
    #  end

    #  it "lists each user & total time" do
    #    first_user7.should have_content 'Prince 30 min'
    #    second_user7.should have_content 'King 30 min'
    #  end
    #end
  end
end

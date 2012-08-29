require 'spec_helper'

describe "Posts index, toplist" do
  context "without users" do
    before(:each) do
      visit posts_path(month:'2012/7')
    end

    it "displays no toplists" do
      page.should_not have_div(:toplists)
    end
  end

  context "with users, not logged in" do
    before(:each) do
      create_member(userid:'Prince')
      visit posts_path(month:'2012/7')
    end

    it "displays no toplists" do
      page.should_not have_div(:toplists)
    end
  end

  context "with users, logged in" do
    before(:each) do
      @prince = create_member(userid:'Prince')
      @king = create_member(userid:'King')
      login(@prince)
    end

    context "without posts" do
      before(:each) do
        visit posts_path(month:'2012/7')
      end

      it "displays toplists" do
        page.should have_div(:toplists)
      end

      it "lists each user & total time" do
        first_user7.should have_content 'Prince 0 min'
        second_user7.should have_content 'King 0 min'
      end
    end

    context "with posts, within scope" do
      before(:each) do
        create_post(user:@prince, duration:30, date:"#{Date.today - 7.days}")
        create_post(user:@king, duration:80, date:"#{Date.today}")
        visit posts_path(month:'2012/7')
      end

      it "displays toplists" do
        page.should have_div(:toplists)
      end

      it "lists each user & total time" do
        first_user7.should have_content 'King 80 min'
        second_user7.should have_content 'Prince 30 min'
      end
    end

    context "with posts, outside scope" do
      before(:each) do
        create_post(user:@prince, duration:30, date:"#{Date.today - 8.days}")
        create_post(user:@king, duration:80, date:"#{Date.today + 1.day}")
        visit posts_path(month:'2012/7')
      end

      it "lists each user & total time" do
        first_user7.should have_content 'Prince 0 min'
        second_user7.should have_content 'King 0 min'
      end
    end
  end
end

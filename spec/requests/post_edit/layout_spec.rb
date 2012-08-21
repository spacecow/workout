require 'spec_helper'

describe "Post edit" do
  context "without posts" do
    before(:each) do
      login
      prince = FactoryGirl.create(:user, userid:'Prince')
      post = FactoryGirl.create(:post, date:Date.parse('2012-7-2'), author:prince, time_of_day:Time.zone.parse('11:15'), duration:35, distance:9, comment:'Just some random comment.')
      visit edit_post_path(post, date:'2012-7-2', month:'2012/7')
    end

    it "has no div for the posts" do
      page.should_not have_div(:posts)
    end

    it "has a new post title" do
      page.should have_title('Edit Post')
    end

    it "has the date field filled in" do
      value('* Date').should eq '2012-07-02'
    end

    it "has the time of day field filled in" do
      value('Time of day').should eq "11:15" 
    end
    it "has the duration field filled in" do
      value('Duration').should eq "35"
    end

    it "has the distance field filled in" do
      value('Distance').should eq "9" 
    end

    it "has the comment field filled in" do
      value('Comment').should eq "\nJust some random comment." 
    end

    it "has a create button" do
      page.should have_submit_button('Update Post')
    end
    it "has a cancel button" do
      page.should have_cancel_button 'Cancel'
    end
  end
end

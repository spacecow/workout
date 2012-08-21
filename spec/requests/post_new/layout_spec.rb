require 'spec_helper'

describe "Post new" do
  context "without posts" do
    before(:each) do
      login
      visit new_post_path(date:'2012-7-2', month:'2012/7')
    end

    it "has no div for the posts" do
      page.should_not have_div(:posts)
    end

    it "has a new post title" do
      page.should have_title('2012-07-02')
    end

    it "has the date field filled in" do
      value('* Date').should eq '2012-07-02'
    end

    it "has the time of day left blank" do
      value('Time of day').should be_nil 
    end
    it "has the duration left blank" do
      value('Duration').should be_nil 
    end

    it "has the distance field blank" do
      value('Distance').should be_nil
    end

    it "has the comment field blank" do
      value('Comment').should be_empty
    end

    it "has a create button" do
      page.should have_submit_button('Create Post')
    end
    it "has a cancel button" do
      page.should have_cancel_button 'Calendar'
    end
  end

  context "with posts on different day" do
    before(:each) do
      FactoryGirl.create(:post, date:Date.parse('2012-7-10'))
      login
      visit new_post_path(date:'2012-7-2', month:'2012/7')
    end

    it "has no div for the posts" do
      page.should_not have_div(:posts)
    end
  end

  context "with posts on the same day" do
    before(:each) do
      prince = FactoryGirl.create(:user, userid:'Prince')
      @post = FactoryGirl.create(:post, date:Date.parse('2012-7-2'), author:prince, duration:35, comment:'Just some random comment.')
      login
      visit new_post_path(date:'2012-7-2', month:'2012/7')
    end

    it "has a div for the posts" do
      page.should have_div(:posts)
    end
    it "has a div for each post" do
      div(:posts).divs_no(:post).should be(1)
    end

    it "has an author" do
      div(:post,0).div(:author).should have_content('by Prince')
    end 

    it "has a timestamp" do
      div(:post,0).div(:timestamp).should have_content('35 min')
    end

    it "has a comment" do
      div(:post,0).div(:comment).should have_content('Just some random comment.')
    end

    it "has an edit link" do
      div(:post,0).div(:actions).should have_link('Edit')
      div(:post,0).div(:actions).click_link 'Edit'
      current_path.should eq edit_post_path(@post)
    end

    it "has a delete link" do
      div(:post,0).div(:actions).should have_link('Delete')
      lambda{ div(:post,0).div(:actions).click_link 'Delete'}.should change(Post,:count).by(-1)
      current_path.should eq new_post_path
      page.should have_content('2012-07-02')
    end
  end
end

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

    it "has the training type blank" do
      value('Training Type').should be_nil
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

    it "has the training partners listed" do
      options('Training Partner').should eq 'BLANK'
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

  context "error page" do
    before(:each) do
      login
      date = '2012-7-2'
      FactoryGirl.create(:post, date:Date.parse(date))
      visit new_post_path(date:date)
      fill_in 'Date', with:''
      click_button 'Create Post'
    end

    it "still has the same title" do
      page.should have_title('2012-07-02')
    end

    it "has posts listed" do
      page.should have_div(:posts)
    end
  end

  context "with posts on the same day" do
    before(:each) do
      @author = FactoryGirl.create(:user, userid:'Prince')
      king = FactoryGirl.create(:user, userid:'King')
      @type = FactoryGirl.create(:training_type, name:'Running')
      @post = FactoryGirl.create(:post, date:Date.parse('2012-7-2'), author:@author, duration:35, comment:'Just some random comment.', training_type:@type)
      @post.training_partners << king
      login
      visit new_post_path(date:'2012-7-2', month:'2012/7')
    end

    it "has a div for the posts" do
      page.should have_div(:posts)
    end
    it "has a div for each post" do
      div(:posts).divs_no(:post).should be(1)
    end

    it "has the traning type as the post title" do
      div(:post,0).div(:title).should have_link('Running')
    end

    it "link from type title redirects to the training type show page" do
      div(:post,0).div(:title).click_link 'Running'
      current_path.should eq training_type_path(@type) 
    end

    context "div author" do
      it "contains the author" do
        first_post_author.should have_content('by Prince')
      end

      it "has a link to the author show page" do
        first_post_author.should have_link('Prince')
      end

      it "links to the author show page" do
        first_post_author.click_link 'Prince'
        current_path.should eq user_path(@author)
      end
    end 

    it "has a timestamp" do
      div(:post,0).div(:timestamp).should have_content('35 min')
    end

    it "has a training partner" do
      div(:post,0).div(:training_partners).should have_content('King')
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
      first_post_actions.should have_link('Delete')
    end

    context "delete" do
      before(:each) do
        lambda{ first_post_actions.click_link 'Delete'}.should change(Post,:count).by(-1)
      end

      it "redirects back" do
        current_path.should eq new_post_path
      end

      it "redirects back to the correct page" do
        page.should have_content('2012-07-02')
      end
    end
  end
end

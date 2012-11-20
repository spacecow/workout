require 'spec_helper'

describe "Day show, comment" do
  before(:each) do
    @date = '2012-07-02'
    @post = create_post(date:@date, author:'Prince')
    @user = @post.author
    login(@user)
  end

  context "layout, without comments" do
    before(:each) do
      visit day_path(@date)
    end

    it "has no comments div" do
      div(:main).should_not have_div(:comments)
    end

    it "the new comment field is empty" do
      first_post_comment_value.should be_empty
    end

    it "has a Comment button" do
      first_post.should have_submit_button('Comment')
    end
  end

  context "layout, with comments" do
    before(:each) do
      FactoryGirl.create(:comment, content:'Yeah!', commenter:@user, commentable:@post) 
      @post.last_comment.update_column(:updated_at,1.hour.ago)
      visit day_path(@date)
    end

    it "has a comments div" do
      div(:main).should have_div(:comments)
    end

    it "each comment has a div" do
      div(:main).div(:comments).divs_no(:comment).should eq 1
    end

    it "displays the comment" do
      first_comment_content.should have_content 'Yeah!'
    end

    it "displays the timestamp" do
      first_comment_timestamp.should have_content 'about 1 hour ago'
    end

    it "displays the commenter" do
      first_comment_commenter.should have_content 'by Prince'
    end

    it "displays the commenter as a link" do
      first_comment_commenter.should have_link 'Prince'
    end

    context "link to commenter" do
      before(:each) do
        first_comment.click_link 'Prince'
      end

      it "redirects to that user" do
        current_path.should eq user_path(@user)
      end
    end
  end

  context "comment" do
    before(:each) do
      FactoryGirl.create(:comment, content:'Yeah!', commentable:@post) 
      visit day_path(@date)
      first_post.fill_in 'comment_content', with:'Okidoki'
    end

    it "saves a comment to db" do
      lambda{ first_post.click_button 'Comment'
      }.should change(Comment,:count).by(1)
    end

    context "saved" do
      before(:each) do
        first_post.click_button 'Comment'
        @comment = Comment.last
      end

      it "redirects back to the day page" do
        current_path.should eq day_path(@date)
      end

      it "has a flash message" do
        page.should have_notice('Comment created')
      end

      it "saves the content" do
        @comment.content.should eq 'Okidoki'
      end

      it "saves the commenter" do
        @comment.commenter.should eq @user
      end

      it "saves the post" do
        @comment.commentable.should eq @post
      end
    end

    context "error" do
      before(:each) do
        first_post.fill_in 'comment_content', with:''
        first_post.click_button 'Comment'
      end

      it "has the date as title" do
        page.should have_title(@date)
      end

      it "has the date field filled in" do
        value('* Date').should eq @date 
      end

      it "has a comments div" do
        div(:main).should have_div(:comments)
      end

      it "each comment has a div" do
        div(:main).div(:comments).divs_no(:comment).should eq 1
      end

      it "the new comment field is empty" do
        first_post_comment_value.should be_empty
      end

      it "has a Comment button" do
        first_post.should have_submit_button('Comment')
      end
      #it "comment cannot be left blank" do
      #  first_post.div(:comment).should have_blank_error 
      #end
    end
  end
end

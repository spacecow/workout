require 'spec_helper'

describe "Day show, comment", focus:true do
  before(:each) do
    @date = '2012-07-02'
    @post = create_post(date:@date)
    login
  end

  context "layout, without comments" do
    before(:each) do
      visit day_path(@date)
    end

    it "has no comments div" do
      page.should_not have_div(:comments)
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
      @post.comments.create!(content:'Yeah!') 
      visit day_path(@date)
    end

    it "has a comments div" do
      page.should have_div(:comments)
    end

    it "each comment has a div" do
      div(:comments).divs_no(:comment).should eq 1
    end
  end

  context "comment" do
    before(:each) do
      @post.comments.create!(content:'Yeah!') 
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
        page.should have_div(:comments)
      end

      it "each comment has a div" do
        div(:comments).divs_no(:comment).should eq 1
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

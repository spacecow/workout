require 'spec_helper'

describe "Comments index", focus:true do
  before(:each) do
    login
    @post = create_post
  end

  context "no comments" do
    before(:each) do
      visit post_comments_path(@post)
    end

    it "has a title" do
      page.should have_title('Comments')
    end

    it "has no comments div" do
      page.should_not have_div(:comments)
    end

    it "has a new comment link" do
      bottom_links.should have_link 'New Comment'
    end

    context "click New Comment" do
      before(:each) do
        click_link 'New Comment'
      end
    
      it "redirects to the new comment page for that post" do
        current_path.should eq new_post_comment_path(@post)
      end
    end
  end

  context "with comments" do
    before(:each) do
      @post.comments.create(content: 'Yeah!')
      visit post_comments_path(@post)
    end

    it "has no comments div" do
      page.should have_div(:comments)
    end

    it "has a div for each comment" do
      div(:comments).divs_no(:comment).should be 1
    end

    it "displays the content of the comment" do
      first_comment.should have_content('Yeah!')
    end
  end
end

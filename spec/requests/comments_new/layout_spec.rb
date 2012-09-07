require 'spec_helper'

describe "Comments new", focus:true do
  before(:each) do
    login
    @post = create_post
    visit new_post_comment_path(@post)
  end

  it "has a title" do
    page.should have_title 'New Comment'
  end

  it "comment field is empty" do
    value('Content').should be_empty
  end

  it "has a Comment button" do
    form.should have_submit_button('Comment')
  end
end


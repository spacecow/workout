require 'spec_helper'

describe "Comments new", focus:true do
  before(:each) do
    login
    @post = create_post
    visit new_post_comment_path(@post)
    fill_in 'Content', with:'Coffee Late'
    #click_button 'Comment'
  end

  it "" do
  end
end

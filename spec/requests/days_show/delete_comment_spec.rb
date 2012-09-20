require 'spec_helper'

describe 'Day show, delete comment' do
  before(:each) do
    login
    @date = '2012-07-15'
    post = create_post(date:@date)
    FactoryGirl.create(:comment, content:'Oh yeah!', commentable:post)
    visit day_path(@date)
  end

  context "delete comment" do
    before(:each) do
      lambda{ first_post_first_comment.click_link 'Delete'
      }.should change(Comment,:count).by(-1)
    end

    it "redirects to the day page" do
      current_path.should eq day_path(@date)
    end

    it "shows a flash message" do
      page.should have_notice('Comment deleted')
    end
  end
end

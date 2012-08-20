require 'spec_helper'

describe 'Posts detail' do
  context 'with posts' do
    before(:each) do
      prince = FactoryGirl.create(:user, userid:'Prince')
      FactoryGirl.create(:post, date:Date.parse('2012-7-10'), author:prince)
      visit detail_posts_path(date:'2012-7-5')
    end

    it "has the date as a title" do
      page.should have_title('2012-07-05')
    end
  end
end

require 'spec_helper'

describe "Post edit, update topentries" do
  before(:each) do
    post = create_post(date:'2012-08-01', author:'Prince')
    login(post.author)
    post = create_post(date:'2012-08-30', user:post.author)
    visit edit_post_path(post)
  end

  context "updates values" do
    it "duration" do
      fill_in 'Duration', with:99
      click_button 'Update Post'
      Post.last.duration.should be 99 
    end 

    context "topentry does not exist" do
      it "saves no topentries to db" do
         lambda{ click_button 'Update Post' 
        }.should change(Topentry,:count).by(2)
      end
    end
  end
end


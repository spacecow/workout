require "spec_helper"

describe "User show" do
  context 'without posts' do
    before(:each) do
      user = FactoryGirl.create(:user, userid:'Prince') 
      login(user)
      visit user_path(user)
    end

    it "has the userid as title" do
      page.should have_title('Prince')
    end

    it "has a calendar button" do
      page.should have_cancel_button 'Calendar'
    end
  end

  context "with posts as partner" do
    before(:each) do
      user = login
      post = FactoryGirl.create(:post)
      post.training_partners << user
      visit user_path(user)
    end

    it "displays posts" do
      page.should have_div(:posts)
    end
  end

  context "with author posts" do
    before(:each) do
      @date = '2012-08-22'
      user = login
      @running = FactoryGirl.create(:training_type, name:'Running')
      FactoryGirl.create(:post, author:user, training_type:@running, date:Date.parse(@date))
      visit user_path(user)
    end

    it "has the type as post title" do
      first_post_title.should have_link('Running')
    end

    context "link from date title" do
      before(:each) do
        first_post_title.click_link('2012-08-22')
      end

      it "redirects to the new post page" do
        current_path.should eq new_post_path
      end
      it "redirects to correct new post page" do
        page.should have_title('2012-08-22')
      end
    end

    it "has date as post title" do
      first_post_title.should have_link(@date)
    end

    it "link from type title redirects to the type show page" do
      first_post_title.click_link('Running')
      current_path.should eq training_type_path(@running)
    end
  end    
end

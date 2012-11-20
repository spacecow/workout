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
      post = create_post
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
      @post = create_post(date:@date, type:'<<<Running>>>') 
      @running = @post.training_types.first
      @author = @post.author
      login(@author)
      visit user_path(@author)
    end

    it "has the type as post title" do
      first_post_title.should have_link('Running')
    end

    it "has the date as post title" do
      first_post_title.should have_link('2012-08-22')
    end

    context "link from date title" do
      before(:each) do
        first_post_title.click_link('2012-08-22')
      end

      it "redirects to the new post page" do
        current_path.should eq day_path('2012-08-22')
      end
    end

    context "edit link" do
      before(:each) do
        first_post_actions.click_link 'Edit'
      end

      it "redirects to the edit post page" do
        current_path.should eq edit_post_path(@post)
      end

      context "cancel" do
        before(:each) do
          click_button 'Cancel'
        end

        it "redirects back to the user page" do
          current_path.should eq user_path(@author)
        end
      end

      context "update" do
        before(:each) do
          click_button 'Update Post'
        end

        it "redirects back to the user page" do
          current_path.should eq user_path(@author)
        end
      end

      context "error" do
        before(:each) do
          fill_in 'Date', with:''
          click_button 'Update Post'
        end

        context "cancel" do
          before(:each) do
            click_button 'Cancel'
          end

          it "redirects back to the user page" do
            current_path.should eq user_path(@author)
          end
        end

        context "update" do
          before(:each) do
            fill_in 'Date', with:@date
            click_button 'Update Post'
          end

          it "redirects back to the user page" do
            current_path.should eq user_path(@author)
          end
        end
      end
    end #edit link
    ############################################

    context "delete link" do
      it "exits" do
        first_post_actions.should have_link('Delete')
      end

      context "delete" do
        before(:each) do
          lambda{ first_post_actions.click_link 'Delete'}.should change(Post,:count).by(-1)
        end

        it "redirects back" do
          current_path.should eq user_path(@author)
        end
      end
    end #delete link
    ############################################

    it "has date as post title" do
      first_post_title.should have_link(@date)
    end

    it "link from type title redirects to the type show page" do
      first_post_title.click_link('Running')
      current_path.should eq training_type_path(@running)
    end
  end    
end

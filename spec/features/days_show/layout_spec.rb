require 'spec_helper'

describe "Day show" do
  context "without posts" do
    before(:each) do
      @user = create_member
      login(@user)
    end

    context "new post form" do
      before(:each) do
        visit day_path('2012-7-2')
      end

      it "has the date as title" do
        page.should have_title('2012-07-02')
      end

      it "has no div for the posts" do
        page.should_not have_div(:posts)
      end

      it "has a new post title" do
        page.should have_title('2012-07-02')
      end

      it "has a title for the new post form" do
        page.should have_h2('New Post')
      end

      it "has the date field filled in" do
        value('* Date').should eq '2012-07-02'
      end

      it "has the training type blank" do
        value('Training Types').should be_blank
      end

      it "has the time of day left blank" do
        value('Time of day').should be_nil
      end
      it "has the duration left blank" do
        value('Duration').should be_nil
      end

      it "has the distance field blank" do
        value('Distance').should be_nil
      end

      it "has the comment field blank" do
        value('Comment').should be_empty
      end

      it "has the training partners listed" do
        options('Training Partner').should eq 'BLANK'
    end

      it "has a create button" do
        form(:new_post).should have_submit_button('Create Post')
      end
    end

    context "new current state form" do
      context "current state on different day" do
        before(:each) do
          day = FactoryGirl.create(:day, date:'2012-7-3')
          state = FactoryGirl.create(:current_state, weight:84, day:day, user:@user)
          visit day_path('2012-7-2')
        end

        it "has the weight field blank" do
          value('Weight').should be_nil
        end
      end

      context "current state with different user" do
        before(:each) do
          date = '2012-7-2'
          day = FactoryGirl.create(:day, date:date)
          state = FactoryGirl.create(:current_state, weight:84, day:day)
          visit day_path(date)
        end

        it "has the weight field blank" do
          value('Weight').should be_nil
        end
      end
    end

    context "edit current state form" do
      before(:each) do
        date = '2012-7-2'
        day = FactoryGirl.create(:day, date:date)
        state = FactoryGirl.create(:current_state, weight:84, day:day, user:@user)
        @form_id = "edit_current_state_#{state.id}"
        visit day_path(date)
      end

      it "exists" do
        page.should have_form(@form_id)
      end

      #it "has a cancel button" do
      #  form(:cancel_current_state).should have_cancel_button 'Calendar'
      #end
    end
  end

  context "with posts on different day" do
    before(:each) do
      create_post({date:'2012-7-10'})
      login
      visit day_path('2012-7-2')
    end

    it "has no div for the posts" do
      page.should_not have_div(:posts)
    end
  end

  context "with posts on the same day" do
    before(:each) do
      @date = '2012-07-02'
      @post = create_post(date:@date, type:'<<<Running>>>', author:'Prince', duration:35, distance:8, partner:'King', comment:'Just some random comment.')
      login(@post.author)
      visit day_path(@date)
    end

    it "has a div for the posts" do
      page.should have_ul(:posts,0)
    end
    it "has a div for each post" do
      ul(:posts,0).lis_no(:post).should be(1)
    end

    context "training type" do
      it "has it as the post title" do
        first_post_title.should have_link('Running')
      end

      it "links to the training type show page" do
        first_post_title.click_link 'Running'
        current_path.should eq training_type_path(TrainingType.last) 
      end
    end

    context "author" do
      it "contains the author" do
        first_post_author.should have_content('by Prince')
      end

      it "has a link to the author show page" do
        first_post_author.should have_link('Prince')
      end

      it "links to the author show page" do
        first_post_author.click_link 'Prince'
        current_path.should eq user_path(User.first)
      end
    end 

    it "has a distance meter" do
      first_post_distance.should have_content('8 km')
    end

    it "has a timestamp" do
      first_post_timestamp.should have_content('35 min')
    end

    context "training partners" do
      it "contains the training partners" do
        first_post_training_partners.should have_content('with King')
      end

      it "has a link to the partner show page" do
        first_post_training_partners.should have_link('King')
      end

      it "links to the partner show page" do
        first_post_training_partners.click_link 'King'
        current_path.should eq user_path(User.last)
      end
    end

    it "has a comment" do
      first_post_comment.should have_content('Just some random comment.')
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

        it "redirects back to the type page" do
          current_path.should eq day_path(@date)
        end
      end

      context "update" do
        before(:each) do
          click_button 'Update Post'
        end

        it "redirects back to the type page" do
          current_path.should eq day_path(@date)
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

          it "redirects back to the type page" do
            current_path.should eq day_path(@date)
          end
        end

        context "update" do
          before(:each) do
            fill_in 'Date', with:@date
            click_button 'Update Post'
          end

          it "redirects back to the type page" do
            current_path.should eq day_path(@date)
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
          current_path.should eq day_path('2012-07-02')
        end
      end
    end #delete link
    ############################################

    it "has a comment link" do
      first_post_actions.should have_link('Comment')
    end #comment link
    ############################################
  end
end

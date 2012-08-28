require 'spec_helper'

describe "Day show" do
  context "without posts" do
    before(:each) do
      user = create_member
      login(user)
      visit day_path('2012-7-2')
    end

    it "has a new post title" do
      page.should have_title('2012-07-02')
    end

    it "has no div for the posts" do
      page.should_not have_div(:posts)
    end

    it "has a new post title" do
      page.should have_title('2012-07-02')
    end

    it "has the date field filled in" do
      value('* Date').should eq '2012-07-02'
    end

    it "has the training type blank" do
      value('Training Type').should be_nil
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
      page.should have_submit_button('Create Post')
    end
    it "has a cancel button" do
      page.should have_cancel_button 'Calendar'
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
      @post = create_post({date:@date, type:'Running', author:'Prince', duration:35, partner:'King', comment:'Just some random comment.'})
      author = @post.author
      login(author)
      visit day_path(@date)
    end

    it "has a div for the posts" do
      page.should have_div(:posts)
    end
    it "has a div for each post" do
      div(:posts).divs_no(:post).should be(1)
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

    context "edit link", focus:true do
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

    it "has a delete link" do
      first_post_actions.should have_link('Delete')
    end

    context "delete" do
      before(:each) do
        lambda{ first_post_actions.click_link 'Delete'}.should change(Post,:count).by(-1)
      end

      it "redirects back" do
        current_path.should eq day_path('2012-7-2')
      end
    end
  end
end

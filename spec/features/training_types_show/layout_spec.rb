require "spec_helper"

describe "TrainingType show" do
  context 'without posts' do
    before(:each) do
      post = create_post(type:'<<<Running>>>')
      login(post.author)
      @type = post.training_types.first
      visit training_type_path(@type)
    end

    it "has a title" do
      page.should have_title('Running')
    end

    it "has a form title" do
      page.should have_h2('New Post')
    end

    it "has a new post form" do
      page.should have_form(:new_post)
    end

    it "has the date value blank" do
      value('* Date').should be_nil
    end

    it "has the training type set" do
      value('Training Types').should eq @type.id.to_s 
    end

    it "has the training partners listed" do
      options('Training Partner').should eq 'BLANK'
    end

    it "has a calendar button" do
      page.should have_cancel_button 'Calendar'
    end
  end

  context 'with posts' do
    before(:each) do
      login
      @post = create_post({type:'<<<Running>>>', date:'2012-07-15'})
      @type = @post.training_types.first
      visit training_type_path(@type)
    end

    it "has the date as the post title" do
      first_post_title.should have_link('2012-07-15')
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
          current_path.should eq training_type_path(@type)
        end
      end

      context "update" do
        before(:each) do
          click_button 'Update Post'
        end

        it "redirects back to the type page" do
          current_path.should eq training_type_path(@type)
        end
      end

      context "error" do
        before(:each) do
          fill_in 'Training Type', with:''
          click_button 'Update Post'
        end

        context "cancel" do
          before(:each) do
            click_button 'Cancel'
          end

          it "redirects back to the type page" do
            current_path.should eq training_type_path(@type)
          end
        end

        context "update" do
          before(:each) do
            fill_in 'Training Type', with:@type.id
            click_button 'Update Post'
          end

          it "redirects back to the type page" do
            current_path.should eq training_type_path(@type)
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
          current_path.should eq training_type_path(@type)
        end
      end
    end #delete link
    ############################################

    context "link from date title" do
      before(:each) do
        first_post_title.click_link('2012-07-15')
      end

      it "redirects to the day page" do
        current_path.should eq day_path('2012-07-15')
      end
    end
  end
end

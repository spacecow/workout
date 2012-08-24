require 'spec_helper'

describe "Day show", focus:true do
  context "without posts" do
    before(:each) do
      login
      visit day_path('2012-7-2')
    end

    it "has a new post title" do
      page.should have_title('2012-07-02')
    end

    it "has no div for the posts" do
      page.should_not have_div(:posts)
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
      date = '2012-7-2'
      author = create_post({date:date, type:'Running', author:'Prince', duration:35, partner:'King', comment:'Just some random comment.'})
      login(author)
      visit day_path(date)
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

    it "has an edit link" do
      first_post_actions.should have_link('Edit')
      first_post_actions.click_link 'Edit'
      current_path.should eq edit_post_path(Post.last)
    end

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

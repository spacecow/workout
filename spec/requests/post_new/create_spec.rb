require 'spec_helper'

describe "Post new" do
  before(:each) do
    login
    visit new_post_path(date:'2012-7-2',month:'2012/7')
    fill_in 'Distance', with:'10'
    fill_in 'Duration', with:'30'
    fill_in 'Time of day', with:'11:15'
    fill_in 'Comment', with:'Some random comment.'
    fill_in 'Training Type', with:'<<<Running>>>'
  end

  context "create" do
    it "saves the post to db" do
      lambda{ click_button 'Create Post'
      }.should change(Post,:count).by(1)
      Post.count.should be 1
    end

    context "with existing training type" do
      before(:each) do
        training_type = FactoryGirl.create(:training_type)
        fill_in 'Training Type', with:training_type.id
      end

      it "adds no training type to db" do
        lambda{ click_button 'Create Post'
        }.should change(TrainingType,:count).by(0)
      end
    end

    context "with a new training type" do
      before(:each) do
        fill_in 'Training Type', with:'<<<Running>>>'
      end

      it "adds a training type to db" do
        lambda{ click_button 'Create Post'
        }.should change(TrainingType,:count).by(1)
      end
    end

    context "saves" do
      before(:each) do 
        click_button 'Create Post'
        @post = Post.last
      end

      it "an author reference" do
        @post.author.should eq User.last 
      end
      it "the date" do
        @post.date.should eq Date.parse('2012-7-2')
      end
      it "the distance" do
        @post.distance.should eq 10
      end
      it "the duration of the post" do
        @post.duration.should eq 30 
      end
      it "the time of day" do
        @post.time_of_day.strftime("%H:%M").should eq "11:15"
      end
      it "the comment of the post" do
        @post.comment.should eq "Some random comment." 
      end

      it "and redirect back to the day page" do
        page.current_path.should eq new_post_path
        page.should have_content('2012-07-02')
      end
    end
  end

  context "cancel" do
    context "from the main page" do
      it "saves no booking to db" do
        lambda{ click_button 'Calendar'
        }.should change(Post,:count).by(0)
      end

      it "redirect back to the calendar page" do
        click_button 'Calendar'
        page.current_path.should eq posts_path
        page.should have_content('July 2012')
      end
    end

    context "from the error page" do
      before(:each) do
        fill_in 'Date', with:''
        click_button 'Create Post'
        click_button 'Calendar'
      end

      it "redirect back to the calendar page" do
        page.current_path.should eq posts_path
        page.should have_content('July 2012')
      end
    end
  end

  context "error" do
    it "date cannot be left blank" do
      fill_in 'Date', with:''
      click_button 'Create Post'
      div(:date).should have_blank_error
    end
  end
end

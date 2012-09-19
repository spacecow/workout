require 'spec_helper'

describe "Day show" do
  before(:each) do
    user = create_member
    login(user)
    FactoryGirl.create(:user,userid:'Prince')
    date = '2012-07-02'
    create_post(date:date, user:user)
    visit day_path(date)
    fill_in 'Distance', with:'10'
    fill_in 'Duration', with:'30'
    fill_in 'Time of day', with:'11:15'
    fill_in 'Comment', with:'Some random comment.'
    fill_in 'Training Type', with:'<<<Running>>>'
    select 'Prince', from:'Training Partner'
  end

  it "has a div for the posts" do
    page.should have_div(:posts)
  end

  context "create" do
    context "saves" do
      before(:each) do 
        click_button 'Create Post'
        @post = Post.last
      end

      it "an author reference" do
        @post.author.should eq User.first 
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
      it "the intensity" do
        @post.intensity.should eq 5
      end
      it "the comment of the post" do
        @post.comment.should eq "Some random comment." 
      end
      it "an partner reference" do
        @post.training_partners.should eq [User.last]
      end
      it "and redirect back to the day page" do
        current_path.should eq day_path('2012-07-02')
      end

      it "shows a flash message" do
        page.should have_notice 'Post created'
      end
    end

    it "saves the post to db" do
      lambda{ click_button 'Create Post'
      }.should change(Post,:count).by(1)
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
  end

  context "error" do
    context "date cannot be left blank" do
      before(:each) do
        fill_in 'Date', with:''
        click_button 'Create Post'
      end

      it "has blank error" do
        div(:date).should have_blank_error
      end

      it "leaves date field blank" do
        value('* Date').should be_nil
      end

      it "training type has no blank error" do
        div(:training_type).should_not have_blank_error
      end
    end

    context "training type cannot be left blank" do
      before(:each) do
        fill_in 'Date', with:'2012-07-05'
        fill_in 'Training Type', with:''
        click_button 'Create Post'
      end

      it "has blank error" do
        div(:training_type).should have_blank_error
      end
      
      it "leaves date field changed" do
        value('* Date').should eq '2012-07-05'
      end

      it "date has no blank error" do
        div(:date).should_not have_blank_error
      end
    end
  end

  context 'error page' do
    before(:each) do
      fill_in 'Date', with:''
    end

    it "stil has the same title" do
      click_button 'Create Post'
      page.should have_title('2012-07-02')
    end

    it "has the training partners listed" do
      select '', from:'Training Partner'
      click_button 'Create Post'
      options('Training Partner').should eq 'BLANK, Prince'
    end

    it "has no div for the posts" do
      click_button 'Create Post'
      page.should_not have_div(:posts)
    end
  end

  context "cancel" do
    context "from the main page" do
      it "saves no post to db" do
        lambda{ click_button 'Calendar'
        }.should change(Post,:count).by(0)
      end

      it "redirect back to the calendar page" do
        click_button 'Calendar'
        page.current_path.should eq posts_path
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
      end
    end
  end
end

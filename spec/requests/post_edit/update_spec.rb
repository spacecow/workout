require 'spec_helper'

describe "Post edit" do
  before(:each) do
    king = create_member({userid:'King'})
    login(king)
    prince = FactoryGirl.create(:user, userid:'Prince')
    day = FactoryGirl.create(:day, date:Date.parse('2012-7-2'))
    post = FactoryGirl.create(:post, day:day , author:prince, time_of_day:Time.zone.parse('11:15'), duration:35, distance:9, comment:'Just some random comment.')
    visit edit_post_path(post, date:'2012-7-2',month:'2012/7')
    fill_in 'Distance', with:'10'
    fill_in 'Duration', with:'30'
    fill_in 'Time of day', with:'11:20'
    fill_in 'Date', with:'2012-7-3'
    fill_in 'Comment', with:'Some random comment.'
    fill_in 'Training Type', with:'<<<Running>>>'
  end

  context "update" do
    it "saves the post to db" do
      lambda{ click_button 'Update Post'
      }.should change(Post,:count).by(0)
      Post.count.should be 1
    end

    context "values" do
      before(:each) do 
        click_button 'Update Post'
        @post = Post.last
      end

      it "an author reference" do
        @post.author.should eq User.last 
      end
      it "the date" do
        @post.date.should eq Date.parse('2012-7-3')
      end
      it "the distance" do
        @post.distance.should eq 10
      end
      it "the duration of the post" do
        @post.duration.should eq 30 
      end
      it "the time of day" do
        @post.time_of_day.strftime("%H:%M").should eq "11:20"
      end
      it "the comment of the post" do
        @post.comment.should eq "Some random comment." 
      end

      it "and redirect back to the page of that day" do
        page.current_path.should eq day_path('2012-07-03')
      end

      it "shows a flash message", focus:true do
        page.should have_notice 'Successfully updated Post'
      end
    end
  end

  context "cancel" do
    context "from the main page" do
      it "updates no post in db" do
        lambda{ click_button 'Cancel'
        }.should change(Post,:count).by(0)
      end

      it "redirect back to the new post page" do
        click_button 'Cancel'
        page.current_path.should eq day_path('2012-07-02')
      end
    end

    context "from the error page" do
      before(:each) do
        fill_in 'Date', with:''
        click_button 'Update Post'
        click_button 'Cancel'
      end

      it "redirect back to the new post page" do
        page.current_path.should eq day_path('2012-07-02')
      end
    end
  end

  context "error" do
    before(:each) do
      fill_in 'Date', with:''
      click_button 'Update Post'
    end

    it "page has possible training partners listed" do
      options('Training Partner').should eq 'BLANK, King'
    end

    it "date cannot be set blank" do
      div(:date).should have_blank_error
    end
  end
end

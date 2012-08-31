require 'spec_helper'

describe "Day show, update topentries" do
  before(:each) do
    @user = login
    visit day_path('2012-07-15')
    fill_in 'Training Type', with:'<<<Running>>>'
  end

  it "saves a post to db" do
    lambda{ click_button 'Create Post'
    }.should change(Post,:count).by(1)
  end

  it "creates no entries if no posts" do
    lambda{ click_button 'Create Post'
    }.should change(Topentry,:count).by(0)
  end

  context "existing posts" do
    context "younger than timeframe" do 
      before(:each) do
        create_post(date:'2012-07-13', user:@user)
      end

      it "saves no topentries to db" do
        lambda{ click_button 'Create Post'
        }.should change(Topentry,:count).by(0)
      end
    end

    context "older than timeframe" do 
      before(:each) do
        create_post(date:'2012-07-01', user:@user)
        create_post(date:'2012-07-13', user:@user)
      end

      it "saves topentries to db" do
        lambda{ click_button 'Create Post'
        }.should change(Topentry,:count).by(1)
      end

      context "with newer entries within timeframe" do
        before(:each) do
          create_post(date:'2012-07-15', user:@user)
          create_post(date:'2012-07-16', user:@user)
          create_post(date:'2012-07-17', user:@user)
          create_post(date:'2012-07-18', user:@user)
          create_post(date:'2012-07-19', user:@user)
          create_post(date:'2012-07-20', user:@user)
          create_post(date:'2012-07-21', user:@user)
          create_post(date:'2012-07-22', user:@user)
        end

        it "saves topentries to db" do
          lambda{ click_button 'Create Post'
          }.should change(Topentry,:count).by(7)
        end
      end #with newer entries within timeframe

      context "with other users" do
        before(:each) do
          create_post(date:'2012-07-15', user:@user)
          other = FactoryGirl.create(:user)
          create_post(date:'2012-07-01', user:other)
          create_post(date:'2012-07-15', user:other)
        end

        it "saves topentries to db" do
          lambda{ click_button 'Create Post'
          }.should change(Topentry,:count).by(2)
        end
      end
    end
  end
end
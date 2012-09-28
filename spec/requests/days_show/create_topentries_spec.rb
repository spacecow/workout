require 'spec_helper'

describe "Day show, create topentries", focus:true do
  before(:each) do
    @user = login
    Date.stub(:today).and_return Date.parse('2012-09-27')
    visit day_path('2012-09-27')
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

  context "post older than timeframe" do
    before(:each) do
      create_post(date:'2012-08-01', user:@user)
    end

    it "saves topentries to db" do
      lambda{ click_button 'Create Post'
      }.should change(Topentry,:count).by(4)
    end
  end
end

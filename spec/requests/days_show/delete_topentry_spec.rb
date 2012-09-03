require 'spec_helper'

describe "Day show, delete topentries" do
  before(:each) do
    @user = login
    date = '2012-07-15'
    create_post(date:'2012-07-01', user:@user)
    create_post(date:date, user:@user, duration:10)
    visit day_path(date)
  end

  it "adds no new entry to db" do
    lambda{ first_post_actions.click_link 'Delete'
    }.should change(Topentry,:count).by(0)
  end

  context "saves values" do
    before(:each) do
      create_post(date:'2012-07-16', user:@user, duration:10, entry:10)
      create_post(date:'2012-07-17', user:@user, entry:10, duration:10)
      create_post(date:'2012-07-18', user:@user, entry:10, duration:10)
      create_post(date:'2012-07-19', user:@user, entry:10, duration:10)
      create_post(date:'2012-07-20', user:@user, entry:10, duration:10)
      create_post(date:'2012-07-21', user:@user, entry:10, duration:10)
      create_post(date:'2012-07-22', user:@user, entry:10, duration:10)
      first_post_actions.click_link 'Delete'
    end

    it "updates the score" do
      Topentry.find_by_day_id(Day.find_by_date('2012-07-15')).score.should eq 0
      Topentry.find_by_day_id(Day.find_by_date('2012-07-16')).score.should eq 10
      Topentry.find_by_day_id(Day.find_by_date('2012-07-17')).score.should eq 20
      Topentry.find_by_day_id(Day.find_by_date('2012-07-18')).score.should eq 30
      Topentry.find_by_day_id(Day.find_by_date('2012-07-19')).score.should eq 40
      Topentry.find_by_day_id(Day.find_by_date('2012-07-20')).score.should eq 50
      Topentry.find_by_day_id(Day.find_by_date('2012-07-21')).score.should eq 60
      Topentry.find_by_day_id(Day.find_by_date('2012-07-22')).score.should eq 10
    end
  end
end

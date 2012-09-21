require 'spec_helper'

describe Topentry do
  before(:each) do
    @date = '2012-09-20'
    @user = FactoryGirl.create(:user, userid:'Prince')
    create_post(date:'2012-09-01', user:@user)
  end

  describe "#generate_missing_entries" do
    it "none if the timespan is too short", focus:true do
      lambda do
        Topentry.update_forward_day_entries(7, [@user], '2012-09-05')
      end.should change(Topentry,:count).by(0)
    end

    it "none if the user has no match" do
      king = FactoryGirl.create(:user, userid:'King')
      lambda do
        Topentry.update_forward_day_entries(7, [king], @date)
      end.should change(Topentry,:count).by(0)
    end

    it "saves to db if author exist" do
      Date.stub(:today).and_return Date.parse(@date)
      create_post(date:@date, user:@user)
      lambda do
        Topentry.update_forward_day_entries(7, [@user], @date)
      end.should change(Topentry,:count).by(2)
    end

    it "saves to db if training partner exist"
    it "saves to db if author & training partner exist"
  end
end

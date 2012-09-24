require 'spec_helper'

describe Topentry do

  describe "#update_forward_day_entries" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @date = Date.parse('2012-09-05')
      create_post(date:@date-29.day, user:@user, duration:30)
    end

    it "none if the timespan is too short" do
      Date.stub(:today).and_return @date-30.day 
      lambda do
        Topentry.update_forward_day_entries([@user], @date)
      end.should change(Topentry,:count).by(0)
    end

    it "none if the user has no match" do
      king = FactoryGirl.create(:user, userid:'King')
      lambda do
        Topentry.update_forward_day_entries([king], @date)
      end.should change(Topentry,:count).by(0)
    end

    it "saves to db if author exist" do
      Date.stub(:today).and_return @date 
      lambda do
        Topentry.update_forward_day_entries([@user], @date)
      end.should change(Topentry,:count).by(4)
    end

    context "saves values of" do
      before(:each) do
        Date.stub(:today).and_return @date+1.day
        Topentry.update_forward_day_entries([@user], @date)
      end

      it "score" do
        Topentry.all.map{|e| e.score}.should eq [0,0,0,0,30,0,0,0]
      end 
      it "duration" do
        Topentry.all.map{|e| e.duration}.should eq [7,7,7,7,30,30,30,30]
      end 
      it "user" do
        Topentry.all.map{|e| e.user}.should eq [@user,@user,@user,@user,@user,@user,@user,@user]
      end 
      it "date" do
        Topentry.all.map{|e| e.full_date}.should eq ['2012-09-05','2012-09-05','2012-09-06','2012-09-06','2012-09-05','2012-09-05','2012-09-06','2012-09-06']
      end 
      it "category" do
        Topentry.all.map{|e| e.category}.should eq ['duration','distance','duration','distance','duration','distance','duration','distance']
      end 
    end

  #  it "saves to db if training partner exist"
  #  it "saves to db if author & training partner exist"
  end
end

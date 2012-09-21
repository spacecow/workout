require 'spec_helper'

describe Topentry do

  describe "#update_forward_day_entries" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @date = Date.parse('2012-09-05')
      create_post(date:'2012-09-04', user:@user, duration:30)
    end

    it "none if the timespan is too short" do
      Date.stub(:today).and_return @date+1.day 
      lambda do
        Topentry.update_forward_day_entries(7, [@user], @date)
      end.should change(Topentry,:count).by(0)
    end

    it "none if the user has no match" do
      king = FactoryGirl.create(:user, userid:'King')
      lambda do
        Topentry.update_forward_day_entries(7, [king], @date)
      end.should change(Topentry,:count).by(0)
    end

    it "saves to db if author exist" do
      lambda do
        Topentry.update_forward_day_entries(7, [@user], @date)
      end.should change(Topentry,:count).by(4)
    end

    context "saves values of" do
      before(:each) do
        Topentry.update_forward_day_entries(7, [@user], @date)
      end

      it "score" do
        Topentry.all.map{|e| e.score}.should eq [30,0,0,0]
      end 
      it "duration" do
        Topentry.all.map{|e| e.duration}.should eq [7,7,7,7]
      end 
      it "user" do
        Topentry.all.map{|e| e.user}.should eq [@user,@user,@user,@user]
      end 
      it "date" do
        Topentry.all.map{|e| e.full_date}.should eq ['2012-09-10','2012-09-10','2012-09-11','2012-09-11']
      end 
      it "category" do
        Topentry.all.map{|e| e.category}.should eq ['duration','distance','duration','distance']
      end 
    end

  #  it "saves to db if training partner exist"
  #  it "saves to db if author & training partner exist"
  end
end

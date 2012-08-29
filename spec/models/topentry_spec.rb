require 'spec_helper'

describe Topentry do
  describe "generate_total_missing_entries", focus:true do
    before(:each) do
      @user = FactoryGirl.create(:user, userid:'Prince')
    end

    it "none if there are no posts" do
      lambda do
        Topentry.generate_total_missing_entries(7)
      end.should change(Topentry,:count).by(0)
    end

    context "with posts" do
      before(:each) do
        create_post(date:'2012-08-01', user:@user, duration:30)
      end

      it "" do
        lambda do
          Topentry.generate_total_missing_entries(7, '2012-08-10')
        end.should change(Topentry,:count).by(3)
      end
    end
  end

  describe "generate_missing_entries" do
    before(:each) do
      @user = FactoryGirl.create(:user, userid:'Prince')
    end

    context "no posts" do
      it "generates no entries" do
        lambda do
          Topentry.generate_missing_entries(7,@user)
        end.should change(Topentry,:count).by(0)
      end
    end

    context "posts older than timeframe" do
      before(:each) do
        create_post(date:'2012-08-01', user:@user, duration:30)
        create_post(date:'2012-08-10', user:@user, duration:40)
      end

      context "not yet generated" do
        it "saves entry to db" do
          lambda do
            Topentry.generate_missing_entries(7, @user, '2012-08-15')
          end.should change(Topentry,:count).by(1)
        end

        context "values" do
          before(:each) do
            Topentry.generate_missing_entries(7, @user, '2012-08-15')
            @entry = Topentry.last
          end

          it "saves the score" do
            @entry.score.should eq 40
          end
          it "saves the duration" do
            @entry.duration.should eq 7
          end

          it "saves the day" do
            @entry.day.should eq Day.where(date:'2012-08-15').first
          end

          it "saves the user" do
            @entry.user.should eq @user
          end
        end
      end

      context "already generated" do
        before(:each) do
          date = '2012-08-15'
          day = FactoryGirl.create(:day, date:date)
          FactoryGirl.create(:topentry, user:@user, day:day, duration:7)
        end

        it "saves no entry to db" do
          lambda do
            Topentry.generate_missing_entries(7, @user, '2012-08-15')
          end.should change(Topentry,:count).by(0)
        end
      end
    end

    context "posts not older than timeframe" do
      before(:each) do
        create_post(date:'2012-08-01', user:@user, duration:10)
      end

      context "not yet generated" do
        it "generates no entries" do
          lambda do
            Topentry.generate_missing_entries(7, @user, '2012-08-02')
          end.should change(Topentry,:count).by(0)
        end
      end
    end
  end
end

require 'spec_helper'

describe Topentry do
  before(:each) do
    @user = FactoryGirl.create(:user, userid:'Prince')
  end

  describe "generate_total_missing_entries" do
    it "none if there are no posts" do
      lambda do
        Topentry.generate_total_missing_entries(7)
      end.should change(Topentry,:count).by(0)
    end

    context "with posts" do
      context "multiple users" do
        before(:each) do
          @king = FactoryGirl.create(:user, userid:'King')
          create_post(date:'2012-08-01', user:@user, duration:30)
          create_post(date:'2012-08-02', user:@king, duration:30)
        end

        it "saves to db for each user" do
          lambda do
            Topentry.generate_total_missing_entries(7, '2012-08-10')
          end.should change(Topentry,:count).by(7)
        end
      end
    end
  end

  describe "generate_missing_entries" do
    context "no posts" do
      it "generates no entries" do
        lambda do
          Topentry.generate_missing_entries(7,@user)
        end.should change(Topentry,:count).by(0)
      end
    end #no posts

    context "another user's post" do
      before(:each) do
        @king = FactoryGirl.create(:user, userid:'King')
        create_post(date:'2012-08-01', user:@king)
      end

      it "saves no entry to db" do
        lambda do
          Topentry.generate_missing_entries(7, @user, '2012-08-15')
        end.should change(Topentry,:count).by(0)
      end
    end #another user's post


    context "partner to post" do
      before(:each) do
        create_post(date:'2012-08-01', user_partner:@user)
      end

      it "saves entry to db" do
        lambda do
          Topentry.generate_missing_entries(7, @user, '2012-08-15')
        end.should change(Topentry,:count).by(1)
      end
    end #another user's post


    context "posts older than timeframe" do
      before(:each) do
        create_post(date:'2012-08-01', user:@user)
        create_post(date:'2012-08-10', user:@user, duration:30)
      end

      context "already generated" do
        before(:each) do
          day = FactoryGirl.create(:day, date:'2012-08-15')
          FactoryGirl.create(:topentry, user:@user, day:day, duration:7)
        end

        it "saves no entry to db" do
          lambda do
            Topentry.generate_missing_entries(7, @user, '2012-08-15')
          end.should change(Topentry,:count).by(0)
        end
      end #already generated

      context "not get generated" do
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
            @entry.score.should eq 30
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
        end #values
      end #not yet generated
    end #posts older than timeframe


    context "posts not older than timeframe" do
      before(:each) do
        create_post(date:'2012-08-01', user:@user)
      end

      context "not yet generated" do
        it "generates no entries" do
          lambda do
            Topentry.generate_missing_entries(7, @user, '2012-08-02')
          end.should change(Topentry,:count).by(0)
        end
      end
    end #posts not older than timeframe
  end #generate missing entries
end

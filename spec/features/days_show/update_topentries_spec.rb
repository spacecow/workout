require 'spec_helper'

describe "Day show, update topentries" do
  before(:each) do
    @user = login
    Date.stub(:today).and_return Date.parse('2012-09-27')
    visit day_path('2012-09-27')
    fill_in 'Training Type', with:'<<<Running>>>'
    fill_in 'Duration', with:'50'
    fill_in 'Distance', with:'9'
  end

  it "saves a post to db" do
    lambda{ click_button 'Create Post'
    }.should change(Post,:count).by(1)
  end

  it "creates no entries if no posts" do
    lambda{ click_button 'Create Post'
    }.should change(Topentry,:count).by(0)
  end

  context "generates entries" do
    context "if post older than timeframe" do
      before(:each) do
        create_post(date:'2012-09-21', user:@user, duration:60, distance:10, intensity:6)
        lambda do
          Topentry.generate_total_missing_entries(7)
        end.should change(Topentry,:count).by(2)
      end

      context "creates values" do
        it "score" do
          Topentry.all.map(&:score).should eq [72,10]
        end
      end

      it "updates topentries to db" do
        lambda{ click_button 'Create Post'
        }.should change(Topentry,:count).by(0)
      end

      context "updates values" do
        before(:each) do
          click_button 'Create Post'
        end
      
        it "score" do
          Topentry.all.map(&:score).should eq [122,19]
        end
      end

      it "updates topentries (two post on same day) to db" do
        create_post(date:'2012-09-27', user:@user, duration:20, distance:5)
        lambda{ click_button 'Create Post'
        }.should change(Topentry,:count).by(0)
      end

      context "updates values" do
        before(:each) do
          create_post(date:'2012-09-27', user:@user, duration:20, distance:5)
          click_button 'Create Post'
        end
      
        it "score" do
          Topentry.all.map(&:score).should eq [142,24]
        end
      end
    end
  end
end

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
    Date.stub(:today).and_return Date.parse('2012-07-15')
    lambda{ click_button 'Create Post'
    }.should change(Topentry,:count).by(0)
  end

  context "existing topentries" do
    context "older than timeframe" do
      before(:each) do
        fill_in 'Duration', with:100
        fill_in 'Distance', with:15
        create_post(date:'2012-07-01', user:@user)
        create_entry(date:'2012-07-16', user:@user, duration:7, score:10)
      end

      it "saves topentries to db" do
        Date.stub(:today).and_return Date.parse('2012-07-16')
        lambda{ click_button 'Create Post'
        }.should change(Topentry,:count).by(3)
      end

      it "updates/sets the score" do
        click_button 'Create Post'
        Topentry.find_by_day_id_and_category(Day.find_by_date('2012-07-15'), 'duration').score.should eq 100
        Topentry.find_by_day_id_and_category(Day.find_by_date('2012-07-16'), 'duration').score.should eq 100
        Topentry.find_by_day_id_and_category(Day.find_by_date('2012-07-15'), 'distance').score.should eq 15
        Topentry.find_by_day_id_and_category(Day.find_by_date('2012-07-16'), 'distance').score.should eq 15
      end
    end
  end

  context "existing posts" do
    context "younger than timeframe" do 
      before(:each) do
        create_post(date:'2012-07-13', user:@user)
      end

      it "saves no topentries to db" do
        Date.stub(:today).and_return Date.parse('2012-07-16')
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
        Date.stub(:today).and_return Date.parse('2012-07-15')
        lambda{ click_button 'Create Post'
        }.should change(Topentry,:count).by(2)
      end

      context "with newer entries within timeframe" do
        before(:each) do
          Date.stub(:today).and_return Date.parse('2012-07-22')
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
          }.should change(Topentry,:count).by(14)
        end
      end #with newer entries within timeframe

      context "with other users" do
        before(:each) do
          create_post(date:'2012-07-15', user:@user)
          other = FactoryGirl.create(:user, userid:'King')
          create_post(date:'2012-07-01', user:other)
          create_post(date:'2012-07-15', user:other)
        end

        it "only interested parties' (author) topentries are updated" do
          Date.stub(:today).and_return Date.parse('2012-07-15')
          lambda{ click_button 'Create Post'
          }.should change(Topentry,:count).by(2)
        end

        it "only interested parties' (author&training partner) topentries are updated" do
          visit day_path('2012-07-15')
          fill_in 'Training Type', with:'<<<Running>>>'
          select 'King', from:'Training Partner'
          Date.stub(:today).and_return Date.parse('2012-07-15')
          lambda{ click_button 'Create Post'
          }.should change(Topentry,:count).by(4)
        end
      end
    end
  end
end

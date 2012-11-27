require 'spec_helper'

describe Post do
  describe "#interval_start" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @date = Date.parse('2012-09-10')
    end

    it "date must be input as Date" do
      lambda{ Post.interval_start(7,@user,@date.full)
      }.should raise_error(AssertionFailure,"date must be input as Date to interval_start")
    end

    it "no posts" do
      Post.interval_start(7,@user,@date).should eq @date+1.day
    end

    it "one day less than interval" do
      create_post(date:'2012-09-01', user:@user)
      Post.interval_start(7,@user,@date).should eq @date-6.day
    end

    it "different user than the one in question" do
      create_post(date:'2012-09-01')
      Post.interval_start(7,@user,@date).should eq @date+1.day
    end

    it "not before the first post" do
      create_post(date:'2012-09-09',user:@user)
      Post.interval_start(7,@user,@date).should eq Date.parse('2012-09-09') 
    end
  end

  describe "#interval_end" do
    before(:each) do
      @date = Date.parse('2012-09-10')
    end

    it "date must be input as Date" do
      lambda{ Post.interval_end(7, @date.full)
      }.should raise_error(AssertionFailure,"date must be input as Date to interval_end")
    end

    it "one day less than interval" do
      Post.interval_end(7,@date).should eq @date+6.day
    end

    it "day cannot extend today" do
      Date.stub(:today).and_return @date+1.day
      Post.interval_end(7,@date).should eq @date+1.day
    end
  end

  describe "#post_array" do
    before(:each) do
      @date = Date.parse('2012-09-10')
      @user = FactoryGirl.create(:user)
    end

    it "no posts, returns elements less than span" do
      start_date = Post.interval_start(7,@user,@date)
      end_date = Post.interval_end(7,@date)
      Post.post_array(@user,7,start_date,end_date).count.should be 0 
    end

    it "posts younger than span, returns elements less than span" do
      Date.stub(:today).and_return @date+1.day
      create_post(date:@date, user:@user)
      start_date = Post.interval_start(7,@user,@date)
      end_date = Post.interval_end(7,@date)
      Post.post_array(@user,7,start_date,end_date).count.should be 0 
    end

    it "posts younger than span, returns elements less than span" do
      create_post(date:@date, user:@user, duration:30)
      start_date = Post.interval_start(7,@user,@date)
      end_date = Post.interval_end(7,@date)
      Post.post_array(@user,7,start_date,end_date).should eq [[30,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]] 
    end
  end

  describe ".interested_parties" do
    it "only author" do
      post = create_post(author:'Prince')
      post.interested_parties.should eq [post.author]
    end

    it "author and training partner" do
      post = create_post(author:'Prince', partner:'King')
      post.interested_parties.should eq [post.author] + post.training_partners
    end
  end

  describe ".intensity_colour" do
    it "red" do
      post = create_post
      post.intensity_colour.should eq 'rgba(0,0,255,0.1)'
    end
  end
  describe "#intensity_colour" do
    it "red" do
      Post.intensity_colour("#ff0000").should eq 'rgba(255,0,0,0.1)'
    end
  end

  context "create post" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @early_day = FactoryGirl.create(:day, date:Date.parse('2012-09-24'))
    end

    context "updates user's first post date" do
      it "it does not exist" do
        create_post(day:@early_day, user:@user)
        @user.first_post_date.should eq @early_day.date
      end

      it "if earlier than before" do
        earlier_day = FactoryGirl.create(:day, date:Date.parse('2012-09-23'))
        create_post(day:@early_day, user:@user)
        create_post(day:earlier_day, user:@user)
        @user.first_post_date.should eq earlier_day.date
      end
    end

    context "don't update user's first post date" do
      it "if older than before" do
        later_day = FactoryGirl.create(:day, date:Date.parse('2012-09-25'))
        create_post(day:@early_day, user:@user)
        create_post(day:later_day, user:@user)
        @user.first_post_date.should eq @early_day.date
      end
    end
  end #create post
  ######################################

  context "update post" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @early_day = FactoryGirl.create(:day, date:Date.parse('2012-09-24'))
      @post = create_post(day:@early_day, user:@user)
    end

    context "user's first post date" do
      context "is updated" do
        it "if post gets an earlier date" do
          earlier_day = FactoryGirl.create(:day, date:Date.parse('2012-09-23'))
          @post.update_attributes(day_attributes:{date:earlier_day.date.full})
          User.last.first_post_date.should eq earlier_day.date
        end

        it "if it's set to nil" do
          later_day = FactoryGirl.create(:day, date:Date.parse('2012-09-25'))
          #@user.update_column(:first_post_date,nil)
          #@user.save
          @user.first_post_date = nil
          @post.author.first_post_date = nil
          #why do i have to set both to nil
          #when @user == @post.author ??
          @post.update_attributes(day_attributes:{date:later_day.date.full})
          User.last.first_post_date.should eq later_day.date
        end
      end

      context "is not updated" do
        it "if post has an older date" do
          later_day = FactoryGirl.create(:day, date:Date.parse('2012-09-25'))
          @post.update_attributes(day_attributes:{date:later_day.date.full})
          User.last.first_post_date.should eq @early_day.date
        end
      end
    end
  end

  context "delete post" do
    context "user's first post date" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @early_day = FactoryGirl.create(:day, date:Date.parse('2012-09-24'))
        @post = create_post(day:@early_day, user:@user)
      end

      context "is updated" do
        it "if earliest was deleted" do
          later_day = FactoryGirl.create(:day, date:Date.parse('2012-09-25'))
          create_post(day:later_day, user:@user)
          @user.posts.delete @post
          @user.first_post_date.should eq later_day.date
        end

        it "to nil, if becomes empty" do
          @user.posts.delete @post
          @user.first_post_date.should be_nil
        end
      end 

      context "isn't updated" do
        it "if post is older than earliest" do
          later_day = FactoryGirl.create(:day, date:Date.parse('2012-09-25'))
          later_post = create_post(day:later_day, user:@user)
          @user.posts.delete later_post 
          @user.first_post_date.should eq @early_day.date
        end
      end
    end #user's first post date

    
    it "deletes its typeships too" do
      post = create_post
      lambda do
        lambda do
          lambda do
            post.destroy 
          end.should change(Post,:count).by(-1)
        end.should change(Typeship,:count).by(-1)
      end.should change(TrainingType,:count).by(0)
    end

    it "deletes its trainingships too" do
      partner = FactoryGirl.create(:user)
      post = create_post(partner:partner)
      lambda do
        lambda do
          lambda do
            post.destroy 
          end.should change(Post,:count).by(-1)
        end.should change(Trainingship,:count).by(-1)
      end.should change(User,:count).by(0)
    end
  end

  describe ".training_types" do
    before(:each) do
      @author = FactoryGirl.create(:user)
    end

    it "cannot be left blank" do
      lambda{ @author.posts.create!(day_attributes:{date:'2012-08-29'})}.should raise_error(ActiveRecord::RecordInvalid) 
    end

    context "one type" do
      before(:each) do
        @running = FactoryGirl.create(:training_type, name:'Running')
      end
      
      it "fails if new type already exists" do
        lambda{ @author.posts.create!(day_attributes:{date:'2012-08-29'}, training_type_tokens:'<<<Running>>>')}.should raise_error(ActiveRecord::RecordInvalid) 
      end

      it "passes with one token" do
        lambda do
          lambda do
            lambda do
              @author.posts.create!(day_attributes:{date:'2012-08-29'}, training_type_tokens:@running.id.to_s)
            end.should change(Post,:count).by(1)
          end.should change(Typeship,:count).by(1)
        end.should change(TrainingType,:count).by(0)
      end

      it "passes with one new token" do
        lambda do
          lambda do
            lambda do
              @author.posts.create!(day_attributes:{date:'2012-08-29'}, training_type_tokens:'<<<Jogging>>>')
            end.should change(Post,:count).by(1)
          end.should change(Typeship,:count).by(1)
        end.should change(TrainingType,:count).by(1)
      end

      context "two types" do
        before(:each) do
          @jogging = FactoryGirl.create(:training_type, name:'Jogging')
        end

        it "passes with two tokens" do
          lambda do
            lambda do
              lambda do
                @author.posts.create!(day_attributes:{date:'2012-08-29'}, training_type_tokens:"#{@running.id.to_s}, #{@jogging.id.to_s}")
              end.should change(Post,:count).by(1)
            end.should change(Typeship,:count).by(2)
          end.should change(TrainingType,:count).by(0)
        end
      end
    end #one type
  end
end

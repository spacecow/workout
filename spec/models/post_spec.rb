require 'spec_helper'

describe Post do
  context "delete post" do
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

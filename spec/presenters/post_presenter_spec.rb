require 'spec_helper'

describe PostPresenter do
  let(:post){ stub_model Post }
  let(:presenter){ PostPresenter.new(post,view)}
  describe ".title" do
    let(:run){ create :training_type, name:'Running'}
    let(:day){ create :day, date:Date.parse('2012-11-28')}

    context "date" do
      before{ post.stub(:day){day}}
      subject{ Capybara.string(presenter.title :date).find('div.title a')}
      its(:text){ should eq '2012-11-28' }
      specify{ subject[:href].should eq day_path(day.full_date)}
    end

    context "type" do
      before{ post.stub(:training_types){[run]}}
      subject{ Capybara.string(presenter.title :type).find('div.title a')}
      its(:text){ should eq 'Running' }
      specify{ subject[:href].should eq training_type_path(run)}
    end

    context "typedate" do
      before do
        post.stub(:training_types){[run]}
        post.stub(:day){day}
      end
      context 'type' do
        subject{ Capybara.string(presenter.title :typedate).all('div.title a')[0]}
        its(:text){ should eq 'Running' }
        specify{ subject[:href].should eq training_type_path(run)}
      end
      context 'date' do
        subject{ Capybara.string(presenter.title :typedate).all('div.title a')[1]}
        its(:text){ should eq '2012-11-28' }
        specify{ subject[:href].should eq day_path(day.full_date)}
      end
    end
  end
end

describe PostPresenter do
  let(:post){ create :post }
  let(:presenter){ PostPresenter.new(post,view)}

  describe ".comments, no comments" do
    specify{ presenter.comments.should be_nil } 
  end

  describe ".comments" do
    context "without comments" do
      it{ presenter.comments.should be_nil }
    end

    context "with a new comment" do
      before{ post.comments.new }
      it{ presenter.comments.should be_nil }
    end

    context "with a deleted comment" do
      before do
        controller.stub(:current_user){ nil }
        create :comment, commentable:post, deleted_at:1.day.ago
      end
      it{ presenter.comments.should be_nil }
    end

    context "with comments" do
      let!(:comment){ create :comment, commentable:post }
      before{ controller.stub(:current_user){ nil }}
      subject{ Capybara.string(presenter.comments).find('ul.comments')}
      it{ should have_selector 'li.comment', count:1 }
    end #with comments
  end

  describe ".training_partner" do
    it "no partner" do
      presenter.training_partners.should be_nil 
    end

    context "a partner" do
      let(:partner){ create(:user, userid:'King')}
      before{ post.training_partners << partner }

      context "div.training_partners" do
        subject{ Capybara.string(presenter.training_partners).find('div.training_partners')}
        its(:text){ should eq 'with King' }

        context "a" do
          subject{ Capybara.string(presenter.training_partners).find('div.training_partners a')}
          its(:text){ should eq 'King' }
          specify{ subject[:href].should eq user_path(partner)}
        end
      end
    end
  end

  describe ".timestamp" do
    it "no time" do
      presenter.timestamp.should be_nil 
    end

    context "start time" do
      before{ post.time_of_day = Time.zone.parse('15:30')}
      subject{ Capybara.string(presenter.timestamp).find('div.timestamp')}
      its(:text){ should eq '15:30' }
    end

    context "duration" do
      before{ post.duration = 30 }
      subject{ Capybara.string(presenter.timestamp).find('div.timestamp')}
      its(:text){ should eq '30 min' }
    end

    context "start time & duration" do
      before do
        post.time_of_day = Time.zone.parse('15:30')
        post.duration = 30
      end
      subject{ Capybara.string(presenter.timestamp).find('div.timestamp')}
      its(:text){ should eq '15:30 ~ 16:00' }
    end
  end
end

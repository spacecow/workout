require 'spec_helper'

describe DayPresenter do
  let!(:day){ create :day }
  let(:presenter){ DayPresenter.new(day,view)}

  describe ".posts" do
    context "no posts" do
      it{ presenter.posts(:type).should be_nil }
    end

    context "with posts" do
      before do
        create :post, day:day
        view.stub(:render){nil}
      end
      subject{ Capybara.string(presenter.posts(:type))}
      it{ should have_selector 'ul.posts' }
    end
  end

  describe ".new_post/.edit_post" do
    let(:new_post){ Post.new }
    let(:old_post){ create :post }
    before{ view.stub(:pl){ t(:post,count:1)}}

    context "new state" do
      subject{ Capybara.string(presenter.new_post(new_post,[])).find('div.post.new')}
      it{ should have_selector 'h2', text:'New Post' }
      it{ should have_selector 'form#new_post' }
      it{ should_not have_button 'Cancel' }
    end

    context "new error state" do
      let(:day){ create :day, date:Date.parse('2012-11-21') }
      before{ new_post.save }
      subject{ Capybara.string(presenter.new_post(new_post,[],day_path(day.date))).find('div.post.new')}
      it{ should have_xpath "//form[@class='cancel button' and @action='/days/2012-11-21']" }
      it{ should have_button 'Cancel' }
    end

    context "edit state" do
      subject{ Capybara.string(presenter.edit_post(old_post,[],"")).find('div.post.edit')}
      it{ should_not have_selector 'h2' }
      it{ should have_selector "form#edit_post_#{old_post.id}" }
      it{ should have_button 'Cancel' }
    end
  end

  describe ".current_state_form" do
    let(:new_state){ CurrentState.new }
    let(:old_state){ create :current_state }
    before do
      view.stub(:pl){ t(:current_state,count:1)}
      controller.stub(:current_user){ create :user }
    end

    context "new state" do
      subject{ Capybara.string presenter.current_state_form(new_state)}
      it{ should have_selector 'h2', text:'New Current State' }
      it{ should have_selector 'form#new_current_state' }
    end

    context "edit state" do
      subject{ Capybara.string presenter.current_state_form(old_state)}
      it{ should have_selector 'h2', text:'Edit Current State' }
      it{ should have_selector "form#edit_current_state_#{old_state.id}" }
    end
  end
end

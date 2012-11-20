require 'spec_helper'

describe 'current_states/_form.html.erb' do
  let(:user){ create(:user) }

  describe 'form#new_current_state' do
    let(:current_state){ CurrentState.new }
    before do
      controller.stub(:current_user){ user }
      view.stub(:session_month){ nil }
      view.stub(:pl){ t(:current_state,count:1)}
      render 'current_states/form', current_state:current_state
    end

    subject{ Capybara.string(rendered)}
    it{ should have_selector 'h2', text:'New Current State' }
    it{ should_not have_selector 'form#cancel_current_state' }
    it{ should_not have_selector 'form#delete_current_state' }

    describe 'form#new_current_state' do
      subject{ Capybara.string(rendered).find("form#new_current_state")}
      it{ should have_field 'Weight', with:nil }
      it{ should have_field 'Note', with:'' }
      it{ should have_xpath "//input[@class='button submit' and @value='Save Current State']" }
    end

  end

  describe 'form#edit_current_state' do
    before do
      controller.stub(:current_user){ user }
      view.stub(:session_month){ nil }
      view.stub(:pl){ t(:current_state,count:1)}
    end
    
    context 'user is different' do
      let(:state){ create(:current_state, weight:80)}
      before{ render 'current_states/form', current_state:state }

      subject{ Capybara.string(rendered)}
      it{ should_not have_selector 'form#delete_current_state' }
    end

    context 'base layout' do
      let(:state){ create(:current_state, weight:80, user:user, note:'Just another day')}
      before{ render 'current_states/form', current_state:state }

      subject{ Capybara.string(rendered)}
      it{ should have_selector 'h2', text:'Edit Current State' }
      it{ should_not have_selector 'form#cancel_current_state' }

      describe 'form#edit_current_state' do
        subject{ Capybara.string(rendered).find("form#edit_current_state_#{state.id}")}
        it{ should have_field 'Weight', with:'80' }
        it{ should have_field 'Note', with:'Just another day' }
        it{ should have_xpath "//input[@value='Update Current State' and @class='button submit']" }
      end

      it{ should have_xpath "//form[@id='delete_current_state' and @action='/current_states/#{state.id}']" }
      describe 'form#delete_current_state' do
        subject{ Capybara.string(rendered).find("form#delete_current_state")}
        it{ should have_xpath "//input[@class='delete' and @value='Delete']" }
      end
    end
  end
end

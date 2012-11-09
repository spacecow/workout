require 'spec_helper'

describe 'layouts/_user_nav.html.erb' do
  describe 'div#user_nav' do
    context 'user logged in' do
      let(:user){ create(:user)}
      before do
        view.stub(:pl){ t(:profile,count:1)}
        view.stub(:mess){ nil }
        view.stub(:current_user){ user }
        render 'layouts/user_nav', month:1
      end

      subject{ Capybara.string(rendered).find('div#user_nav')}
      it{ should have_xpath "//a[@href='#{edit_user_path(user)}']", text:'Edit Profile' }
    end
  end
end

require 'spec_helper'

describe 'users/edit.html.erb' do
  before do
    view.stub(:session_month){ 'whatever' }
    view.stub(:pl){ t(:profile,count:1)}
    assign(:user, create(:user))
    render
  end

  subject{ Capybara.string(rendered) }
  it{ should have_selector 'h1', text:'Edit Profile' }
  it{ should have_button 'Calendar' }

  describe 'form.edit_user' do
    subject{ Capybara.string(rendered).find('form.edit_user')}
    it{ should have_field('Image', with:nil) }
    it{ should have_button 'Update User' }
  end
end

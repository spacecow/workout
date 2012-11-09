require 'spec_helper'

describe 'users/edit.html.erb', focus:true do
  before do
    view.stub(:pl){ t(:profile,count:1)}
    assign(:user, create(:user))
    render
  end

  subject{ Capybara.string(rendered) }
  it{ should have_selector 'h1', text:'Edit Profile' }
  it{ p subject.text }

  describe 'form.edit_user' do
    subject{ Capybara.string(rendered).find('form.edit_user')}
    it{ should have_field('Image', with:nil) }
    it{ should have_button 'Update User' }
  end
end

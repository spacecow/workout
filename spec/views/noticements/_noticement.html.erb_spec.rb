require 'spec_helper'

describe 'noticements/_noticement.html.erb' do
  let(:notification){ create :notification } 
  let(:noticement){ stub_model(Noticement, notification:notification, updated_at:1.day.ago)}

  context 'unread' do
    before{ render noticement }
    subject{ Capybara.string(rendered) }
    it{ should have_selector 'li.noticement.unread' }
  end

  context 'read' do
    before do
      noticement.unread = false
      render noticement
    end
    subject{ Capybara.string(rendered) }
    it{ should have_selector 'li.noticement.read' }
  end
end
  #describe 'div#user_nav' do
  #  context 'user logged in' do
  #    let(:user){ create(:user)}
  #    before do
  #      view.stub(:pl){ t(:profile,count:1)}
  #      view.stub(:mess){ nil }
  #      view.stub(:current_user){ user }
  #      render 'layouts/user_nav', month:1
  #    end

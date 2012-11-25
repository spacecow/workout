require 'spec_helper'

describe 'noticements/_noticement.html.erb' do
  let(:noticement){ stub_model(Noticement)}
  before do
    render noticement 
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

require 'spec_helper'

describe UserPresenter do
  #let(:user){ mock_model User }
  #let(:presenter){ UserPresenter.new(user,view)}
  #context '#noticements' do
  #  context 'without noticements' do
  #    specify{ presenter.noticements.should be_nil } 
  #  end

  #  context "with noticements" do
  #    let(:creator){ stub_model User }
  #    let(:notification){ stub_model Notification, creator:creator }
  #    let(:noticements){ [stub_model(Noticement, notification:notification)] }
  #    before{ noticements.stub(:total_pages){0}}
  #    subject{ Capybara.string(presenter.noticements noticements)}
  #    it{ should have_selector 'h2' }
  #    
  #  end
  #end

  #describe '#noticements', focus:true do
  #  let(:ns){ [stub_model(Noticement)] }
  #  before{ view.stub(:render){ nil }} 
  #  subject{ Capybara.string(presenter.noticements(ns))} 
  #  it{ should have_selector 'h2', text:'Live Update' }
  #  it{ should have_selector 'ul.noticements' }
  #end
end

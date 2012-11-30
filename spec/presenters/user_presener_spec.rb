require 'spec_helper'

describe UserPresenter do
  let(:user){ create :user }
  let(:presenter){ UserPresenter.new(user,view)}
  context '#noticements, no noticements' do
    specify{ presenter.noticements.should be_nil } 
  end

  describe '#noticements', focus:true do
    let(:ns){ [stub_model(Noticement)] }
    before{ view.stub(:render){ nil }} 
    subject{ Capybara.string(presenter.noticements(ns))} 
    it{ should have_selector 'h2', text:'Live Update' }
    it{ should have_selector 'ul.noticements' }
  end
end

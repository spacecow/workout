require 'spec_helper'

describe UserPresenter do
  let(:user){ create :user }
  let(:presenter){ UserPresenter.new(user,view)}
  context '#noticements, no noticements' do
    specify{ presenter.noticements.should be_nil } 
  end

  describe '#noticements' do
    before{ create :noticement, user:user }
    subject{ Capybara.string(presenter.noticements)} 
    it{ should have_selector 'h2', text:'Live Update' }
    it{ should have_selector 'ul.noticements li.noticement', count:1 }
  end
end

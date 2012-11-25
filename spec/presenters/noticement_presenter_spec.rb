require 'spec_helper'

describe NoticementPresenter, focus:true do
  let(:notification){ create :notification }
  let(:noticement){ stub_model(Noticement, notification:notification)}
  let(:presenter){ NoticementPresenter.new(noticement,view)}

  context ".content" do
    subject{ Capybara.string(presenter.content)}
    it{ p subject.find('a')[:href]; should have_xpath "//div[@class='content']/a", text:'some notification' } 
  end
end

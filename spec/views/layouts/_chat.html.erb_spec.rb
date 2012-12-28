require 'spec_helper'

describe 'layouts/_chat.html.erb' do
  describe 'div#chat' do
    let(:noticement){ mock_model(Noticement).as_null_object }
    before do
      assign(:noticements, [noticement])
      view.stub(:time_ago_in_words){ "" }
      view.stub(:current_user){ create :user }
      render
    end

    subject{ Capybara.string(rendered).find('div#chat ul.noticements')}
    #it{ should have_selector 'li', count:1 }
  end
end

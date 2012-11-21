require 'spec_helper'

describe 'stats/toplists.html.erb' do
  before do
    view.stub(:pl){ nil }
    render
  end

  subject{ Capybara.string(rendered)}
  it{ should_not have_button 'Calendar' }
end

require 'spec_helper'

describe 'days/show.html.erb' do
  before do
    view.stub(:session_month){ 'whatever' }
    view.stub(:pl).and_return 'blah'
    view.stub(:pl).with(:current_state,1).and_return(t(:current_state,count:1))
    assign(:day, create(:day))
    assign(:current_state, CurrentState.new)
    render
  end

  subject{ Capybara.string(rendered) }
  it{ should have_selector 'h2', text:'New Current State' }
  it{ should have_selector 'form#new_current_state' }
end

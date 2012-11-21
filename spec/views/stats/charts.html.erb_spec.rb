require 'spec_helper'

describe 'stats/charts.html.erb' do
  before do
    assign(:durations7,{})
    assign(:distances7,{})
    assign(:durations30,{})
    assign(:distances30,{})
    assign(:weights,{})
    render
  end

  subject{ Capybara.string(rendered) }
  it{ should_not have_button 'Calendar' }
end

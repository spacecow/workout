require 'spec_helper'

describe 'Day show, delete current state' do
  let(:day){ create(:day, date:'2012-11-19')}
  before do
    user = login
    @state = create(:current_state, day:day, user:user)
    visit day_path(day.date)
  end
  let(:delete_state){ lambda{ click_button 'Delete' }}

  it "deletes current state from db" do
    delete_state.should change(CurrentState,:count).by(-1)
  end

  context 'delete state' do
    before{ delete_state.call }
    specify{ page.should have_content 'Current State deleted' }
  end
end

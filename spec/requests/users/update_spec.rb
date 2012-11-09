require 'spec_helper'

describe 'Users' do
  before do
    login
    visit edit_user_path(user)
  end
end

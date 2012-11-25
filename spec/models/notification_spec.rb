require 'spec_helper'

describe Notification do
  context "create" do
    subject{ create :notification }
    it{ should be_unread }
  end
end

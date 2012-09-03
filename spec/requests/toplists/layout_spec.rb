require 'spec_helper'

describe "Stats toplists", focus:true do
  before(:each) do
    visit stats_toplists_path
  end

  it "has a stats menu" do
    page.should have_div(:stats_menu)
  end
  it "has a charts tab" do
    div(:stats_menu).should have_link('Charts')
  end
  it "has a toplists tab" do
    div(:stats_menu).should have_link('Toplists')
  end

  context "click charts" do
    before(:each) do
      div(:stats_menu).click_link 'Charts'
    end

    it "redirects to the charts page" do
      current_path.should eq stats_charts_path
    end
  end

  context "click toplists" do
    before(:each) do
      div(:stats_menu).click_link 'Toplists'
    end

    it "redirects to the charts page" do
      current_path.should eq stats_toplists_path
    end
  end

  it "has a calendar button" do
    page.should have_cancel_button('Calendar')
  end
end

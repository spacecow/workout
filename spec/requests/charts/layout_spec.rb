require 'spec_helper'

describe "Stats charts", focus:true do
  before(:each) do
    visit stats_charts_path
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

    it "has charts tab selected" do
      div(:stats_menu).should have_xpath("//li[@class='selected' and @id='charts']")
    end 
    it "has not toplists tab selected" do
      div(:stats_menu).should_not have_xpath("//li[@class='selected' and @id='toplists']")
    end 
  end

  context "click toplists" do
    before(:each) do
      div(:stats_menu).click_link 'Toplists'
    end

    it "redirects to the charts page" do
      current_path.should eq stats_toplists_path
    end

    it "has toplist tab selected" do
      div(:stats_menu).should have_xpath("//li[@class='selected' and @id='toplists']")
    end 
    it "has not charts tab selected" do
      div(:stats_menu).should_not have_xpath("//li[@class='selected' and @id='charts']")
    end 
  end

  it "has a calendar button" do
    page.should have_cancel_button('Calendar')
  end

  context "click calendar button" do
    before(:each) do
      click_button('Calendar')
    end

    it "redirects to the calendar page" do
      current_path.should eq posts_path
    end
  end
end

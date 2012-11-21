require 'spec_helper'

describe '_site_menu layout' do
  context 'menu: charts' do
    it "stats_charts path" do visit stats_charts_path end
    after{ find('div#stats_menu').should have_selector 'li#charts.selected' }
  end

  context 'menu: calendar' do
    it "posts path" do visit posts_path end
    after{ find('div#stats_menu').should have_selector 'li#calendar.selected' }
  end

  context 'menu: toplists' do
    it "stats toplists path" do visit stats_toplists_path end
    after{ find('div#stats_menu').should have_selector 'li#toplists.selected' }
  end
end

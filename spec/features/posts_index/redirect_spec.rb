require 'spec_helper'

describe "Posts index" do
  context "redirects" do
    context "param&session variable" do
      before(:each) do
        login
        visit posts_path(month:'2012/7')
        td(:day_0701).click_link '1' 
        click_link 'Calendar'
      end

      it "back to the calendar" do
        current_path.should eq posts_path
      end

      it "back to the same month" do
        page.should have_content('July 2012')
      end
    end

    context "today&session variable" do
      before(:each) do
        login
        visit posts_path
        click_link '15' 
        click_link 'Calendar'
      end

      it "back to the calendar" do
        current_path.should eq posts_path
      end

      it "back to the current month" do
        page.should have_content I18n.t('date.month_names')[Date.today.strftime("%-m").to_i]
      end
    end
  end
end

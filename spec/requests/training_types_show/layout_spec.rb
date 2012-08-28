require "spec_helper"

describe "TrainingType show" do
  context 'without posts' do
    before(:each) do
      login
      @type = FactoryGirl.create(:training_type, name:'Running')
      visit training_type_path(@type)
    end

    it "has a title" do
      page.should have_title('Running')
    end

    it "has a form title" do
      page.should have_h2('New Post')
    end

    it "has a new post form" do
      page.should have_form(:new_post)
    end

    it "has the date value blank" do
      value('* Date').should be_nil
    end

    it "has the training type set" do
      value('Training Type').should eq @type.id.to_s 
    end

    it "has the training partners listed" do
      options('Training Partner').should eq 'BLANK'
    end

    it "has a calendar button" do
      page.should have_cancel_button 'Calendar'
    end
  end

  context 'with posts' do
    before(:each) do
      login
      type = FactoryGirl.create(:training_type, name:'Running')
      day = FactoryGirl.create(:day, date:Date.parse('2012-07-14'))
      FactoryGirl.create(:post, training_type:type, day:day)
      visit training_type_path(type, date:'2012-7-2')
    end

    it "has the date as the post title" do
      first_post_title.should have_link('2012-07-14')
    end

    context "link from date title" do
      before(:each) do
        first_post_title.click_link('2012-07-14')
      end

      it "redirects to the day page" do
        current_path.should eq day_path('2012-07-14')
      end
    end
  end
end

require 'spec_helper'

describe "Day show, new current state" do
  before(:each) do
    @user = login
    @date = '2012-07-02'
    create_post(date:@date)
    visit day_path(@date)
    @day = Day.find_by_date(@date)
  end

  it "has the date as the title" do
    page.should have_title('2012-07-02')
  end

  it "has the weight field empty" do
    value('Weight').should be_nil
  end  

  it "has a div for the posts" do
    page.should have_ul(:posts,0)
  end
  
  context "create" do
    before(:each) do
      fill_in 'Weight', with:'84.5'
    end

    it "saves the current state to db" do
      lambda{ click_button 'Save Current State'
      }.should change(CurrentState,:count).by(1)
    end

    context "save" do
      before(:each) do
        click_button 'Save Current State'
        @current_state = CurrentState.last
      end

      it "day_id is set" do
        @current_state.day.should eq @day
      end

      it "user_id is set" do
        @current_state.user.should eq @user
      end

      it "weight is set" do
        @current_state.weight.should eq "84.5"
      end

      it "redirect to the day show page" do
        current_path.should eq day_path(@date)
      end

      it "shows a flash message" do
        page.should have_notice 'Current State saved'
      end
    end

    context "error, weight cannot be left blank" do
      before(:each) do
        fill_in 'Weight', with:''
        fill_in 'Note', with:''
        click_button 'Save Current State' 
      end

      it "has blank error" do
        div(:weight).should have_blank_error
      end

      it "has no new post form" do
        page.should_not have_form(:new_post)
      end

      it "has no div for the old posts" do
        page.should_not have_div(:posts)
      end

      it "has the date as the title" do
        page.should have_title('2012-07-02')
      end
    end
  end
end

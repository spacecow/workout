require 'spec_helper'

describe PostPresenter do
  describe ".timestamp" do
    it "no time" do
      post = FactoryGirl.create(:post)
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp"></div>' 
    end

    it "start time" do
      post = FactoryGirl.create(:post, time_of_day:Time.zone.parse('15:30'))
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp">15:30</div>' 
    end

    it "duration" do
      post = FactoryGirl.create(:post, duration:30)
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp">30 min</div>' 
    end

    it "start time & duration" do
      post = FactoryGirl.create(:post, time_of_day: Time.zone.parse('15:30'), duration:30)
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp">15:30 ~ 16:00</div>'
    end
  end
end

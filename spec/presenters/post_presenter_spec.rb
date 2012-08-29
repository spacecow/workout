require 'spec_helper'

describe PostPresenter do
  describe ".training_partner" do
    it "no partner" do
      post = create_post
      @presenter = PostPresenter.new(post, view)
      @presenter.training_partners.should eq '<div id="training_partners"></div>' 
    end

    it "a partner" do
      partner = FactoryGirl.create(:user, userid:'King')
      post = create_post 
      post.training_partners << partner
      @presenter = PostPresenter.new(post, view)
      @presenter.training_partners.should eq "<div id=\"training_partners\">with <a href=\"/users/#{partner.id}\">King</a></div>" 
    end
  end

  describe ".timestamp" do
    it "no time" do
      post = create_post 
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp"></div>' 
    end

    it "start time" do
      post = create_post(time_of_day:Time.zone.parse('15:30'))
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp">15:30</div>' 
    end

    it "duration" do
      post = create_post(duration:30)
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp">30 min</div>' 
    end

    it "start time & duration" do
      post = create_post(time_of_day:Time.zone.parse('15:30'), duration:30)
      @presenter = PostPresenter.new(post, view)
      @presenter.timestamp.should eq '<div id="timestamp">15:30 ~ 16:00</div>'
    end
  end
end

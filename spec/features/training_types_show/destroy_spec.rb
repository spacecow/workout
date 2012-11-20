require "spec_helper"

describe "TrainingType show" do
  context 'delete posts' do
    before(:each) do
      login
      post = create_post(type:'<<<Running>>>')
      @type = post.first_type
      visit training_type_path(@type)
      first_post_actions.click_link 'Delete'
    end

    it "redirects back" do
      current_path.should eq training_type_path(@type)
    end
  end
end

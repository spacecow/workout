require "spec_helper"

describe "TrainingType show" do
  context 'create' do
    before(:each) do
      login
      @type = FactoryGirl.create(:training_type, name:'Running')
      visit training_type_path(@type)
      fill_in 'Date', with:'2012-08-23'
    end

    it "saves the post to db" do
      lambda{ click_button 'Create Post'
      }.should change(Post,:count).by(1)
    end

    it "shows a flash message" do
      click_button 'Create Post'
      page.should have_notice('Post created')
    end

    context 'errors page' do
      before(:each) do
        fill_in 'Training Type', with:''
        click_button 'Create Post'
      end

      it "still has the same title" do
        page.should have_title('Running')
      end

      it "redirect to type show page when saved" do
        fill_in 'Training Type', with:'<<<Walking>>>'
        click_button 'Create Post'
        page.current_path.should eq training_type_path(TrainingType.last)
      end

      context 'errors page' do
        before(:each) do
          click_button 'Create Post'
        end

        it "still has the same title" do
          page.should have_title('Running')
        end
      end
    end
  end
end

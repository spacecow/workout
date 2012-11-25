require 'spec_helper'

describe Comment do
  let(:comment){ create :comment, content:'Just some content' }
  describe "#create_notifications" do
    let(:notify){ lambda{ comment.notify }} 
    it "saves notifications to db" do
      lambda{ notify.call }.should change(Notification,:count).by(1)
    end

    context "saves" do
      before{ notify.call }
      subject{ Notification.last } 
      its(:notifiable_id){ should be comment.id }
      its(:notifiable_type){ should eq 'Comment' }
      its(:creator_id){ should be comment.commenter.id }
      its(:type_mask){ should eq Notification.type(:new)}
      its(:content){ should eq 'Just some content'}
      it{ should be_unread }
    end
  end
end

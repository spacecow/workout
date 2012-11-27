require 'spec_helper'

describe Comment do
  let!(:batman){ create :user, userid:'Batman' }
  let!(:joker){ create :user, userid:'Joker' }
  let(:post){ create :post, author:joker }
  let!(:comment){ create :comment, content:'Just some content', commentable:post }
  describe "#notify_old" do
    let(:notify){ lambda{ Comment.notify_old }} 
    it "saves notifications to db" do
      lambda{ notify.call }.should change(Notification,:count).by(1)
    end
    it "saves noticements to db" do
      lambda{ notify.call }.should change(Noticement,:count).by(2)
    end
  end

  describe ".notify" do
    let(:notify){ lambda{ comment.notify(:new) }} 
    it "saves notifications to db" do
      lambda{ notify.call }.should change(Notification,:count).by(1)
    end
    it "saves noticements to db" do
      lambda{ notify.call }.should change(Noticement,:count).by(2)
    end

    context "saves notification" do
      before{ notify.call }
      subject{ Notification.last } 
      its(:notifiable_id){ should be comment.id }
      its(:notifiable_type){ should eq 'Comment' }
      its(:creator_id){ should be comment.commenter.id }
      its(:type_mask){ should eq Notification.type(:new)}
      its(:content){ should eq 'Just some content'}
    end

    context "saves noticements" do
      before{ notify.call }
      subject{ Noticement.all } 
      specify{ subject.map{|e| e.userid}.should eq %w(Batman Joker)}
      specify{ subject.map(&:notification_id).should eq [Notification.last.id, Notification.last.id]}
      specify{ subject.map(&:unread).should eq [true,true]}
    end
  end
end

require 'spec_helper'

describe CommentsController do
  let(:member){ create :user }
  let(:_post){ create :post, author:member }

  describe "create notifications" do
    before do
      session[:userid] = member.id
      request.env["HTTP_REFERER"] = root_path
    end

    context "#create" do
      before do
        post :create, comment:{content:'just a comment'}, post_id:_post.id
      end

      context Comment do
        subject{ Comment }
        its(:count){ should eq 1 }
      end

      context Notification do
        subject{ Notification }
        its(:count){ should eq 1 }
      end

      context 'last notification' do
        subject{ Notification.last }
        its(:type_mask){ should eq Notification.type(:new)}
      end
    end #create

    context "#update" do
      before do
        comment = create :comment, commentable:_post
        put :update, id:comment.id, comment:{content:'just a comment'}, post_id:_post.id
      end

      context 'last comment' do
        subject{ Comment.last }
        its(:content){ should eq 'just a comment' }
      end

      context Notification do
        subject{ Notification }
        its(:count){ should eq 1 }
      end

      context 'last notification' do
        subject{ Notification.last }
        its(:type_mask){ should eq Notification.type(:edit)}
      end
    end #update

    context "#destroy" do
      before do
        comment = create :comment, commentable:_post
        delete :destroy, id:comment.id, post_id:_post.id
      end

      context Comment do
        subject{ Comment }
        its(:count){ should eq 1 }
      end

      context 'last comment' do
        subject{ Comment.last }
        its(:deleted_at){ should_not be_nil }
      end

      context Notification do
        subject{ Notification }
        its(:count){ should eq 1 }
      end

      context 'last notification' do
        subject{ Notification.last }
        its(:type_mask){ should eq Notification.type(:delete)}
      end
    end #destroy
  end #create notifications
end

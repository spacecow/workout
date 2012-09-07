class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    set_user
    @posts = Post.where('author_id = ? OR trainingships.partner_id = ?', @user.id, @user.id).includes(:trainingships)
    @posts.each{|e| e.comments.new}
  end

  private

    def set_user
      session_user(@user.id)
      session_day(nil)
      session_type(nil)
    end
end

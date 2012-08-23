class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @posts = Post.where('author_id = ? OR trainingships.partner_id = ?', @user.id, @user.id).includes(:trainingships)
  end
end

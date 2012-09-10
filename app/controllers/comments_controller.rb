class CommentsController < ApplicationController
  authorize_resource
  before_filter :load_commentable

  def create
    @comment = @commentable.comments.new(params[:comment])
    @comment.commenter = current_user
    if @comment.save
      redirect_to :back, notice:created(:comment)
    else
      @day = @commentable.day
      @post = Post.new
      @post.build_day(date:@day.date.full)
      @posts = Post.where('day_id = ?', @day.id)
      @posts.each{|e| e.comments.new}
      render '/days/show'
    end
  end

  private

    def load_commentable
      klass = [Post].detect{|c| params["#{c.name.underscore}_id"]}
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end
end

class CommentsController < ApplicationController
  authorize_resource
  before_filter :load_commentable

  def create
    @comment = @commentable.comments.new(params[:comment])
    @comment.commenter = current_user
    if @comment.save
      @comment.notify
      redirect_to :back, notice:created(:comment)
    else
      @day = @commentable.day
      @post = Post.new
      @post.build_day(date:@day.date.full)
      @posts = Post.where('day_id = ?', @day.id)
      @posts.each{|e| e.comments.new}
      @current_state = CurrentState.find_or_initialize_by_day_id_and_user_id(@day.id, current_user.id)
      render '/days/show'
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @date = @comment.full_date
    @comment.destroy
    redirect_to day_path(@date), notice:deleted(:comment)
  end

  private

    def load_commentable
      klass = [Post].detect{|c| params["#{c.name.underscore}_id"]}
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end
end

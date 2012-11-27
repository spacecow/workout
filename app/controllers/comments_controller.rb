class CommentsController < ApplicationController
  before_filter :load_commentable
  authorize_resource :commentable
  load_and_authorize_resource through: :commentable

  def create
    #@comment = @commentable.comments.new(params[:comment])
    @comment.commenter = current_user
    if @comment.save
      @comment.notify(:new)
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

  def update
    if @comment.update_attributes(params[:comment])
      @comment.notify(:edit)
      redirect_to :back, notice:updated(:comment)
    end
  end

  def destroy
    #@comment.destroy
    if @comment.act_paranoid!
      redirect_to day_path(@comment.full_date), notice:deleted(:comment)
    end
  end

  private

    def load_commentable
      klass = [Post].detect{|c| params["#{c.name.underscore}_id"]}
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end
end

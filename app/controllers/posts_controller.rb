require 'assert'

class PostsController < ApplicationController
  skip_load_resource :only => [:new,:create]
  load_and_authorize_resource

  before_filter :set_date, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :set_month, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
    @posts = Post.includes(:training_partners)
  end

  def new
    @post = Post.new(date:@date)
    @posts = Post.where(date:@date)
    @training_partners = User.where('id <> ?',current_user.id).map{|e| [e.userid, e.id]}
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to new_post_path(date:@post.date, month:@month)
    else
      @training_partners = User.where('id <> ?',current_user.id).map{|e| [e.userid, e.id]}
      @post.errors.add(:training_type_token, errors(:blank)) if @post.errors.messages[:training_type]
      render :new
    end
  end

  def edit
    @post.time_of_day = @post.time_of_day.strftime("%H:%M") unless @post.time_of_day.nil?
    @training_partners = User.where('id <> ?',@post.author_id).map{|e| [e.userid, e.id]}
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to new_post_path(date:@post.date, month:@month)
    else
      @training_partners = User.where('id <> ?',@post.author_id).map{|e| [e.userid, e.id]}
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to new_post_path(date:@post.date, month:@month)
  end

  private

    def set_date
      assert_not_nil(params[:date]) if $AVLUSA
      @date = Date.parse(params[:date])
    end

    def set_month
      assert_not_nil(params[:month]) if $AVLUSA
      @month = Date.parse(params[:month])
    end
end

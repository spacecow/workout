require 'assert'

class PostsController < ApplicationController
  skip_load_resource :only => [:new,:create]
  load_and_authorize_resource

  before_filter :set_date, :only => [:new, :create]
  before_filter :set_month, :only => [:new, :create]

  def index
    @month = params[:month] ? Date.parse(params[:month]) : Date.today
    @posts = Post.all
  end

  def new
    @post = Post.new(date:@date)
    @posts = Post.where(date:@date)
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      redirect_to new_post_path(date:@post.date, month:@month)
    else
      render :new
    end
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

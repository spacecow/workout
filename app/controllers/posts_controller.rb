require 'assert'

class PostsController < ApplicationController
  skip_load_resource :only => [:new,:create]
  load_and_authorize_resource

  before_filter :set_date, :only => :new

  def index
    set_month
    @posts = Post.includes(:training_partners)
    @posts_by_date = @posts.group_by(&:date)
  end

  def new
    @post = Post.new(date:@date)
    @posts = Post.where(date:@date)
    @training_partners = User.minus(current_user)
    
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      if params[:location] == 'type'
        redirect_to @post.training_type
      else
        redirect_to new_post_path(date:@post.date)
      end
    else
      @training_partners = User.minus(current_user)
      if params[:location] == 'type'
        @training_type = TrainingType.find(session[:type])
        render 'training_types/show'
      else
        @posts = Post.where(date:get_date)
        render :new
      end
    end
  end

  def edit
    @date = @post.date
    @post.time_of_day = @post.time_of_day.strftime("%H:%M") unless @post.time_of_day.nil?
    @training_partners = User.minus(@post.author)
  end

  def update
    @date = @post.date
    if @post.update_attributes(params[:post])
      redirect_to new_post_path(date:@post.date)
    else
      @training_partners = User.minus(@post.author)
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to :back #new_post_path(date:@post.date, month:@month)
  end

  private

    def set_date
      assert_not_nil(params[:date]) if $AVLUSA
      session[:date] = params[:date]
      get_date
    end

    def get_date
      @date = Date.parse(session[:date])
    end
    
    def set_month
      session[:month] = params[:month] || (@month.nil? ? nil : @month.half) || session[:month] || Date.today.half
      @month = Date.parse(session[:month])
    end
end

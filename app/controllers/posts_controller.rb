require 'assert'

class PostsController < ApplicationController
  skip_load_resource :only => [:new,:create]
  load_and_authorize_resource

  def index
    set_month
    @posts = Post.includes(:training_partners)
    @posts_by_date = @posts.group_by{|e| e.day.date}
  end

  #def new
  #  @post = Post.new #(date:@date)
  #  @posts = Post.all #where(date:@date)
  #  @training_partners = User.minus(current_user)
  #end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:notice] = created(:post)
      if session_day.nil?
        redirect_to @post.training_type
      else
        redirect_to day_url(@post.date)
      end
    else
      if @post.errors.messages[:day_id]
        @post.build_day
        @post.day.errors.add(:date, I18n.t('errors.messages.blank')) 
      end
      @training_partners = User.minus(current_user)
      if session_day.nil?
        render 'training_types/show', id:get_training_type 
      else
        render 'days/show', id:get_day
      end
    end
    #@post = current_user.posts.build(params[:post])
    #if @post.save
    #  if params[:location] == 'type'
    #    redirect_to @post.training_type
    #  else
    #    redirect_to new_post_path(date:@post.date)
    #  end
    #else
    #  @training_partners = User.minus(current_user)
    #  if params[:location] == 'type'
    #    @training_type = TrainingType.find(session[:type])
    #    render 'training_types/show'
    #  else
    #    @posts = Post.where('day_id = ?', get_day.id)
    #    render :new
    #  end
    #end
  end

  def edit
    @day = @post.day
    #session[:day] = @day.id
    @post.time_of_day = @post.time_of_day.strftime("%H:%M") unless @post.time_of_day.nil?
    @training_partners = User.minus(@post.author)
  end

  def update
    @day = @post.day
    if @post.update_attributes(params[:post])
      flash[:notice] = updated(:post)
      if !session_type.nil?
        redirect_to @post.training_type
      elsif !session_user.nil?
        redirect_to user_url(@post.author)
      else #!session_day.nil?
        redirect_to day_url(@post.date)
      end
    else
      if @post.errors.messages[:day_id]
        @post.build_day
        @post.day.errors.add(:date, I18n.t('errors.messages.blank')) 
      end
      @training_partners = User.minus(@post.author)
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to :back #new_post_path(date:@post.date, month:@month)
  end

  private

    #def set_date
    #  assert_not_nil(params[:date]) if $AVLUSA
    #  session[:date] = params[:date]
    #  get_date
    #end

    def get_day
      @day = Day.find(session_day)
    end
    def get_training_type
      @training_type = TrainingType.find(session_type)
    end
    
    def set_month
      session[:month] = params[:month] || (@month.nil? ? nil : @month.half) || session[:month] || Date.today.half
      @month = Date.parse(session[:month])
    end
end

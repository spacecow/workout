require 'assert'

class PostsController < ApplicationController
  skip_load_resource :only => [:new,:create]
  load_and_authorize_resource
  cache_sweeper :post_sweeper

  def index
    @selected = :calendar
    set_month
    first = @month.beginning_of_month.beginning_of_week(:monday) - 1.day
    last = @month.end_of_month.end_of_week(:monday)
    @posts = Post.interval(first,last).includes(:training_partners, :day)
    @posts_by_date = @posts.group_by{|e| e.day.date}
    @users = User.all #.sort{|e| e.total_min(7, @posts)}
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      Topentry.update_forward_day_entries(@post.interested_parties, @post.date)
      flash[:notice] = created(:post)
      if session_day.nil?
        redirect_to @post.training_types.first
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
        get_day
        @day.posts.each{|e| e.comments.new}
        render 'days/show'
      end
    end
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
      Topentry.update_forward_day_entries(@post.interested_parties, @post.date)
      flash[:notice] = updated(:post)
      if !session_type.nil?
        redirect_to @post.training_types.first
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
    date = @post.date
    interested_parties = @post.interested_parties

    @post.comments.each do |comment|
      comment.act_paranoid!
    end

    @post.destroy
    Topentry.update_forward_day_entries(interested_parties, date)
    redirect_to :back #new_post_path(date:@post.date, month:@month)
  end

  private

    def get_day
      @day = Day.find_by_date(session_day)
    end
    def get_training_type
      @training_type = TrainingType.find(session_type)
    end
    
    def set_month
      session_month(params[:month] || session_month || Date.today.half)
      @month = Date.parse(session_month)
    end
end

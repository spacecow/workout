class DaysController < ApplicationController
  authorize_resource

  def show
    @day = Day.find_or_create_by_date(params[:id])
    set_day
    @post = Post.new
    @post.build_day(date:@day.date.full)
    #@posts = Post.includes(:training_partners)
    @training_partners = User.minus(current_user)

    @day.posts.each{|e| e.comments.new}

    #@current_state = CurrentState.new(day_id:@day.id)
    @current_state = CurrentState.find_or_initialize_by_day_id_and_user_id(@day.id, current_user.id)
  end

  private

    def set_day
      session_day(@day.date)
      session_type(nil)
      session_user(nil)
    end
end

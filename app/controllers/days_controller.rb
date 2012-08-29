class DaysController < ApplicationController
  authorize_resource

  def show
    @day = Day.find_or_create_by_date(params[:id])
    set_day
    @post = Post.new
    @post.build_day(date:@day.date.full)
    #@posts = Post.includes(:training_partners)
    @posts = Post.where('day_id = ?', @day.id)
    @training_partners = User.minus(current_user)
  end

  private

    def set_day
      session_day(@day.date)
      session_type(nil)
      session_user(nil)
    end
end
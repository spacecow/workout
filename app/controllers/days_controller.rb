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
      session[:day] = @day.id 
      session[:type] = nil
    end
end

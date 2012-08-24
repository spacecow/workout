class DaysController < ApplicationController
  authorize_resource

  def show
    @day = Day.find_or_create_by_date(params[:id])
    #@posts = Post.includes(:training_partners)
    @posts = Post.where('day_id = ?', @day.id)
  end
end

class NoticementsController < ApplicationController
  load_and_authorize_resource

  def index
    @noticements = Noticement.where('created_at > ?', Time.at(params[:after].to_i))
  end

  def read
    @noticement.unread = false
    @noticement.save
    redirect_to day_path(@noticement.full_date)
  end
end

class NoticementsController < ApplicationController
  load_and_authorize_resource

  def read
    @noticement.unread = false
    @noticement.save
    redirect_to day_path(@noticement.full_date)
  end
end

class NoticementPresenter < BasePresenter
  presents :noticement

  def content
    h.content_tag :div, class:'content' do
      h.link_to noticement.content, h.day_path(noticement.full_date)
    end
  end
end

class NoticementPresenter < BasePresenter
  presents :noticement

  def content
    h.content_tag :div, class:'content' do
      h.link_to noticement.info, h.read_noticement_path(noticement), method: :put
    end
  end

  def creator
    h.content_tag :div, class:'creator' do
      "by #{h.link_to noticement.creatorid, noticement.creator}".html_safe
    end
  end
end

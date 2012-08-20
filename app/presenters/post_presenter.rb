class PostPresenter < BasePresenter
  def posts_link(date)
    h.link_to date.day, h.detail_posts_path(date:date.full)
  end
end

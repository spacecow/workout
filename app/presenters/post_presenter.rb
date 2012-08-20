class PostPresenter < BasePresenter
  def posts_count(posts)
    if posts.present?
      posts.group_by(&:author_id).map do |k,v|
        h.content_tag(:div,class:'posts') do
          "#{User.find(k).userid}: #{v.count}" 
        end
      end.join.html_safe
    end
  end

  def posts_link(date)
    h.link_to date.day, h.detail_posts_path(date:date.full)
  end
end

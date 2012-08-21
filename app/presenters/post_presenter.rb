class PostPresenter < BasePresenter
  presents :post

  def author
    h.content_tag(:div, id:"author") do
      h.t(:by,name:post.authorid)
    end
  end

  def comment
    h.content_tag(:div, id:'comment') do
      post.comment
    end
  end

  def posts_count(posts)
    if posts.present?
      posts.group_by(&:author_id).map do |k,v|
        h.content_tag(:div,class:'posts') do
          "#{User.find(k).userid}: #{v.count}" 
        end
      end.join.html_safe
    end
  end

  def posts_link(date,month)
    if h.current_user
      h.link_to date.day, h.new_post_path(date:date.full, month:month.half)
    else
      date.day
    end
  end

  def timestamp
    h.content_tag(:div, id:'timestamp') do
      if post.time_of_day && post.duration
        "#{post.time_of_day.strftime('%H:%M')} ~ #{(post.time_of_day + post.duration.minutes).strftime('%H:%M')}"
      elsif post.time_of_day
        post.time_of_day.strftime('%H:%M') 
      elsif post.duration
        "#{post.duration} min"
      end
    end
  end
end

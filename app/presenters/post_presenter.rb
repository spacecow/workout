class PostPresenter < BasePresenter
  presents :post

  def actions(date,month)
    h.content_tag(:div, id:"actions") do
      "#{edit_link(date,month)} #{delete_link(date,month)}".html_safe
    end
  end

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

  def delete_link(date,month)
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:delete), h.send("post_path", @object, date:date, month:month), method: :delete, data:{confirm:h.sure?} if h.can? :destroy, @object 
  end

  def edit_link(date,month)
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:edit), h.send("edit_#{dcase}_path", @object, date:date, month:month) if h.can? :edit, @object 
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

  def training_type
    h.content_tag(:div, id:"training_type") do
      post.training_type.name
    end
  end
end

class PostPresenter < BasePresenter
  presents :post

  def actions(no)
    h.content_tag(:div, id:"actions") do
      "#{edit_link} #{delete_link} #{comment_link(no)} #{hide_comment_link(no)}".html_safe
    end
  end

  def author
    h.content_tag(:div, id:"author") do
      "#{h.t(:by)} #{h.link_to post.authorid, post.author}".html_safe
    end
  end

  def comment
    h.content_tag(:div, id:'comment') do
      post.comment
    end
  end

  def comment_link(no)
    dcase = @object.class.to_s.downcase
    h.link_to h.pl(:comment,1), nil, {class:'comment', data:{link:no}} if h.can? :new, Comment
  end
  def hide_comment_link(no)
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:hide_comment), nil, {class:'hide_comment', data:{link:no}} if h.can? :new, Comment
  end

  def distance
    unless post.distance.blank?
      h.content_tag(:div, id:'distance') do
        "(#{post.distance} km)"
      end
    end
  end

  def delete_link
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:delete), h.send("post_path", @object), method: :delete, data:{confirm:h.sure?} if h.can? :destroy, @object 
  end

  def edit_link
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:edit), h.send("edit_#{dcase}_path", @object) if h.can? :edit, @object 
  end

  def posts_count(posts)
    if posts.present?
      posts.group_by{|e| ([e.author] | e.training_partners).map(&:userid).join("&")}.map do |k,v|
        h.content_tag(:div,class:'posts') do
          "#{k}: #{v.map(&:duration).sum}" 
        end
      end.join.html_safe
    end
  end

  def posts_link(date)
    if h.current_user
      h.link_to date.day, h.day_path(date.full)
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

  def training_partners
    h.content_tag(:div, id:"training_partners") do
      "with #{post.training_partners.map{|e| h.link_to e.userid, e}.join(" and ")}".html_safe if post.training_partners.present?
    end
  end

  def title(type,title)
    h.content_tag(:div, id:"title") do
      if title == :date
        h.link_to post.date.full, h.day_path(post.date.full)
      elsif title == :typedate
        "#{post.training_types.map{|type| h.link_to type.name, type}.join(', ')}, #{h.link_to post.date.full, h.day_path(post.date.full)}".html_safe
      elsif title == :type
        "#{post.training_types.map{|type| h.link_to type.name, type}.join(', ')}".html_safe
      end
    end
  end
end

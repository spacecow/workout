class PostPresenter < BasePresenter
  presents :post

  def actions(no)
    h.content_tag(:div, class:"actions") do
      "#{edit_link} #{delete_link} #{comment_link(no)} #{hide_comment_link(no)}".html_safe
    end
  end

  def author
    h.content_tag(:div, class:"author") do
      "#{h.t(:by)} #{h.link_to post.authorid, post.author}".html_safe
    end
  end

  def cancel_button(return_path)
    h.form_tag return_path, :method => :get, class:%w(cancel button).join(' ') do 
      h.submit_tag h.t('helpers.submit.cancel'), class: :cancel
    end
  end

  def comment
    h.content_tag(:div, class:'comment') do
      post.comment
    end
  end

  def comment_link(no)
    dcase = @object.class.to_s.downcase
    h.link_to h.pl(:comment,1), nil, {class:'comment', data:{link:no}} if h.can? :new, Comment
  end

  def comments
    h.content_tag :ul, class:'comments' do
      h.render post.comments_official, background:post.intensity_colour
    end if post.comments_official.present?
  end

  def hide_comment_link(no)
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:hide_comment), nil, {class:'hide_comment', data:{link:no}} if h.can? :new, Comment
  end

  def distance
    unless post.distance.blank?
      h.content_tag(:div, class:'distance') do
        "(#{post.distance} km)"
      end
    end
  end

  def delete_link
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:delete), h.send("post_path", @object), method: :delete, data:{confirm:h.sure?} if h.can? :destroy, @object 
  end

  def edit(training_partners, return_path)
    h.content_tag :div, class:%w(edit post).join(' ') do
      form(training_partners) +
      cancel_button(return_path) +
      clear_div
    end 
  end

  def edit_link
    dcase = @object.class.to_s.downcase
    h.link_to h.t(:edit), h.send("edit_#{dcase}_path", @object) if h.can? :edit, @object 
  end

  def image
    h.content_tag :div, class:'image' do
      h.image_tag post.author_image_url(:thumb)
    end
  end

  def form(training_partners)
    h.render 'posts/form', post:post, partners:training_partners, location:'post' unless post.nil?
  end

  def new(training_partners, return_path=nil)
    h.content_tag :div, class:%w(new post).join(' ') do
      "<hr>".html_safe + 
      h.minititle(h.new(:post)) +
      form(training_partners) +
      (cancel_button(return_path) if post.errors.present?) +
      clear_div
    end 
  end

  def posts_count(posts)
    if posts.present?
      posts.group_by{|e| ([e.author] | e.training_partners).map(&:userid).join("&")}.map do |k,v|
        if k =~ /&/
        else
          k = h.image_tag User.find_by_userid(k).image_url(:mini_thumb).to_s
        end 
        colour = Post.colour(v.map{|e| e.intensity*e.duration}.sum/v.map(&:duration).sum)
        h.content_tag(:div,class:'posts',style:'color:'+colour) do
          ("#{k}"+
          h.content_tag(:div,class:'score') do
            v.map(&:duration).sum.to_s
          end).html_safe
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
    h.content_tag(:div, class:'timestamp') do
      if post.time_of_day && post.duration
        "#{post.time_of_day.strftime('%H:%M')} ~ #{(post.time_of_day + post.duration.minutes).strftime('%H:%M')}"
      elsif post.time_of_day
        post.time_of_day.strftime('%H:%M') 
      elsif post.duration
        "#{post.duration} min"
      end
    end unless post.time_of_day.nil? and post.duration.nil?
  end

  def training_partners
    h.content_tag(:div, class:"training_partners") do
      "with #{post.training_partners.map{|e| h.link_to e.userid, e}.join(" and ")}".html_safe
    end if post.training_partners.present?
  end

  def title(title)
    h.content_tag(:div, class:"title") do
      if title == :date
        h.link_to post.full_date, h.day_path(post.full_date)
      elsif title == :typedate
        "#{post.training_types_names_links.map{|e| h.link_to *e}.join(', ')}, #{h.link_to post.full_date, h.day_path(post.full_date)}".html_safe
      elsif title == :type
        post.training_types_names_links.map{|e| h.link_to *e}.join(', ').html_safe
      end
    end
  end
end

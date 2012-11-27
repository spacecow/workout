class CommentPresenter < BasePresenter
  presents :comment

  def actions
    h.content_tag(:div, class:'actions') do
      delete_link
    end
  end

  def commenter
    h.content_tag(:div, class:'commenter') do
      "by #{h.link_to comment.commenterid, comment.commenter}".html_safe
    end
  end

  def content
    h.content_tag(:div, class:'content') do
      comment.content
    end
  end

  def image_mini_thumb
    h.content_tag :div, class:%w(image mini thumb).join(' ') do
      h.image_tag comment.commenter_image_url(:mini_thumb) 
    end 
  end
end

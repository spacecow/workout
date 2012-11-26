class CommentPresenter < BasePresenter
  presents :comment

  def actions(delete)
    h.content_tag(:div, id:'actions') do
      delete_link
    end if delete
  end

  def commenter
    h.content_tag(:div, id:'commenter') do
      "by #{h.link_to comment.commenterid, comment.commenter}".html_safe
    end
  end

  def content
    h.content_tag(:div, id:'content') do
      h.link_to h.simple_format(comment.content), h.day_path(comment.full_date)
    end
  end
end

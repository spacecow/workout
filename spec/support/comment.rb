def comments; div(:main).ul(:comments,0) end
def comment_no(no); comments.li(:comment,no) end
def first_comment; comment_no(0) end
def first_comment_commenter; first_comment.div(:commenter,0) end
def first_comment_content; first_comment.div(:content,0) end
def first_comment_timestamp; first_comment.div(:timestamp,0) end

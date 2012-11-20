def comments; div(:main).div(:comments) end
def comment_no(no); comments.div(:comment,no) end
def first_comment; comment_no(0) end
def first_comment_commenter; first_comment.div(:commenter) end
def first_comment_content; first_comment.div(:content) end
def first_comment_timestamp; first_comment.div(:timestamp) end

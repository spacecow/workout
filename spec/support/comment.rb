def comments; div(:comments) end
def comment_no(no); comments.div(:comment,no) end
def first_comment; comment_no(0) end

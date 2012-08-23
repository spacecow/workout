def postno(no) posts.div(:post,no) end 
def posts; div(:posts) end
def first_post; postno(0) end
def first_post_actions; first_post.div(:actions) end
def first_post_author; first_post.div(:author) end
def first_post_title; first_post.div(:title) end

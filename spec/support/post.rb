def postno(no) posts.div(:post,no) end 
def posts; div(:posts) end
def first_post; postno(0) end
def first_post_actions; first_post.div(:actions) end

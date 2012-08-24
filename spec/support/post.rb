def postno(no) posts.div(:post,no) end 
def posts; div(:posts) end
def first_post; postno(0) end
def first_post_actions; first_post.div(:actions) end
def first_post_author; first_post.div(:author) end
def first_post_comment; first_post.div(:comment) end
def first_post_title; first_post.div(:title) end
def first_post_timestamp; first_post.div(:timestamp) end
def first_post_training_partners; first_post.div(:training_partners) end

def create_post(params = {})
  h = {day:FactoryGirl.create(:day, date:Date.parse('2012-7-14'))}
  h[:day] = FactoryGirl.create(:day, date:Date.parse(params[:date])) if params[:date]
  h[:training_type] = FactoryGirl.create(:training_type, name:params[:type]) if params[:type]
  h[:author] = FactoryGirl.create(:user, userid:params[:author]) if params[:author]
  h[:duration] = params[:duration] if params[:duration]
  h[:comment] = params[:comment] if params[:comment]
  post = FactoryGirl.create(:post,h)
  post.training_partners << FactoryGirl.create(:user, userid:params[:partner]) if params[:partner]
  h[:author] 
end

def postno(no) posts.div(:post,no) end 
def posts; div(:posts) end
def first_post; postno(0) end
def first_post_actions; first_post.div(:actions) end
def first_post_author; first_post.div(:author) end
def first_post_comment; first_post.div(:comment) end
def first_post_title; first_post.div(:title) end
def first_post_timestamp; first_post.div(:timestamp) end
def first_post_training_partners; first_post.div(:training_partners) end

def toplists; div :toplists end
def toplist7; toplists.ul :seven_days end
def toplist7no(no) toplist7.li no end
def first_user7; toplist7no 0 end
def second_user7; toplist7no 1 end

def create_post(params = {})
  h = {day:Day.find_or_create_by_date('2012-7-14'), training_type_tokens:TrainingType.find_or_create_by_name('Swimming').id.to_s}

  h[:training_type_tokens] = params[:type] if params[:type]

  h[:day] = FactoryGirl.create(:day, date:Date.parse(params[:date])) if params[:date]
  h[:day] = params[:day] if params[:day]

  h[:author] = FactoryGirl.create(:user, userid:params[:author]) if params[:author]
  h[:author] = params[:user] if params[:user]


  h[:duration] = params[:duration] if params[:duration]
  h[:distance] = params[:distance] if params[:distance]
  h[:time_of_day] = params[:time_of_day] if params[:time_of_day]
  h[:comment] = params[:comment] if params[:comment]

  post = FactoryGirl.create(:post,h)

  post.training_partners << FactoryGirl.create(:user, userid:params[:partner]) if params[:partner]
  post.training_partners << params[:user_partner] if params[:user_partner]

  post
end
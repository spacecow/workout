def postno(no) posts.div(:post,no) end 
def posts; div(:posts) end

def first_post_commentno(no) first_post_comments.div(:comment,no) end
def first_post_comments; first_post.div(:comments) end
def first_post_first_comment; first_post_commentno(0) end

def first_post; postno(0) end
def first_post_actions; first_post.div(:actions) end
def first_post_author; first_post.div(:author) end
def first_post_comment; first_post.div(:comment) end
def first_post_comment_content; first_post.find_field('comment_content') end
def first_post_comment_value; first_post_comment_content.value end
def first_post_title; first_post.div(:title) end
def first_post_timestamp; first_post.div(:timestamp) end
def first_post_distance; first_post.div(:distance) end
def first_post_training_partners; first_post.div(:training_partners) end

def toplists; div :menu_toplists end
def toplist7; toplists.ul :seven_days end
def toplist7no(no) toplist7.li no end
def first_user7; toplist7no 0 end
def second_user7; toplist7no 1 end

def create_post(params = {})
  h = {day:Day.find_or_create_by_date('2012-7-14'), training_type_tokens:TrainingType.find_or_create_by_name('Swimming').id.to_s}

  h[:training_type_tokens] = params[:type] if params[:type]

  h[:day] = Day.find_or_create_by_date(params[:date]) if params[:date]
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

  h[:author].topentries.create(score:params[:entry], day:h[:day], duration:7, category:'duration') if params[:entry]

  post
end

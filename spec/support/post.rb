def postno(no) posts.li(:post,no) end 
def posts; ul(:posts,0) end

def first_post_commentno(no) first_post_comments.li(:comment,no) end
def first_post_comments; first_post.ul(:comments,0) end
def first_post_first_comment; first_post_commentno(0) end

def first_post; postno(0) end
def first_post_actions; first_post.div(:actions,0) end
def first_post_author; first_post.div(:author,0) end
def first_post_comment; first_post.div(:comment,0) end
def first_post_comment_content; first_post.find_field('comment_content') end
def first_post_comment_value; first_post_comment_content.value end
def first_post_title; first_post.div(:title,0) end
def first_post_timestamp; first_post.div(:timestamp,0) end
def first_post_distance; first_post.div(:distance,0) end
def first_post_training_partners; first_post.div(:training_partners,0) end

def toplists; div :menu_toplists end
def toplist7; toplists.ul :seven_days end
def toplist7no(no) toplist7.li no end
def first_user7; toplist7no 0 end
def second_user7; toplist7no 1 end

def create_post(params = {})
  h = {day_attributes:{date:'2012-7-14'}, training_type_tokens:TrainingType.find_or_create_by_name('Swimming').id.to_s}

  h[:training_type_tokens] = params[:type] if params[:type]

  if params[:date]
    h[:day_attributes] = {}
    h[:day_attributes][:date] = params[:date].instance_of?(Date) ? params[:date].full : params[:date]
  end
  if params[:day]
    h[:day_attributes] = {}
    h[:day_attributes][:date] = params[:day].date.full
  end

  #h[:author] = FactoryGirl.create(:user, userid:params[:author]) if params[:author]
  #h[:author] = params[:user] if params[:user]
  if params[:author]
    user = FactoryGirl.create(:user, userid:params[:author]) 
  elsif params[:user]
    user = params[:user] 
  else
    user = FactoryGirl.create(:user)
  end

  h[:duration] = params[:duration] if params[:duration]
  h[:distance] = params[:distance] if params[:distance]
  h[:intensity] = params[:intensity] if params[:intensity]
  h[:time_of_day] = params[:time_of_day] if params[:time_of_day]
  h[:comment] = params[:comment] if params[:comment]

  #post = FactoryGirl.create(:post,h)
  post = Post.new(h)
  user.posts << post
  post.save!

  post.training_partners << FactoryGirl.create(:user, userid:params[:partner]) if params[:partner]
  post.training_partners << params[:user_partner] if params[:user_partner]

  user.topentries.create(score:params[:entry], day:h[:day], duration:7, category:'duration') if params[:entry]

  post
end

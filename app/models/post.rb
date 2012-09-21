class Post < ActiveRecord::Base
  belongs_to :author, class_name:'User', touch:true
  belongs_to :day, touch:true
  accepts_nested_attributes_for :day

  has_many :typeships, dependent: :destroy
  has_many :training_types, through: :typeships

  has_many :trainingships, dependent: :destroy
  has_many :training_partners, through: :trainingships, source: :partner

  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :distance, :training_type_tokens, :duration, :time_of_day, :comment, :training_partner_ids, :day_attributes, :intensity

  validates_presence_of :day_id, :author_id, :training_type_ids

  after_validation :set_training_type_tokens_error

  MIL_TYPES = { 
                1 => "#00ff00",
                2 => "#00c040",
                3 => "#008080",
                4 => "#0040c0",
                5 => "#0000ff",
                6 => "#3300cc",
                7 => "#660099",
                8 => "#990066",
                9 => "#cc0033",
               10 => "#ff0000",
              }.freeze

  def authorid; author.userid end

  def day_attributes=(params)
    self.day = params[:date].empty? ? nil : Day.find_or_create_by_date(params[:date]) 
  end

  def date; day.date end
  def full_date; date.full end

  def first_type; training_types.first end
  def intensity_colour
    Post.intensity_colour(MIL_TYPES[intensity])
  end
  def interested_parties
    [author] + training_partners
  end
  def last_comment; comments.last end

  def training_type_name; training_type && training_type.name end

  def training_type_tokens
    training_type_ids.join(', ')
  end
  def training_type_tokens=(tokens)
    self.training_type_ids = TrainingType.ids_from_tokens(tokens)
  end

  class << self
    def colour(no)
      MIL_TYPES[no]
    end

    def first_post(user); user(user).order('days.date').includes(:day).first end
    def intensity_colour(code)
      "rgba(#{Colour.rgba_array_dec(code).join(',')})"
    end
    def last_post(user); user(user).order('days.date').includes(:day).last end
    def interval(first,last)
      where("days.date > ? and days.date <= ?", first, last).includes(:day)
    end

    def user(user)
      where("author_id = ? or posts.id = trainingships.post_id and trainingships.partner_id = ?", user.id, user.id).includes(:trainingships)
    end
  end

  private

    def set_training_type_tokens_error
      errors.add(:training_type_tokens, I18n.t('errors.messages.blank')) if errors.messages[:training_type_ids]
    end
end

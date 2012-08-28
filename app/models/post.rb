class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :training_type
  belongs_to :day
  accepts_nested_attributes_for :day

  has_many :trainingships
  has_many :training_partners, through: :trainingships, source: :partner

  attr_accessible :distance, :training_type_token, :duration, :time_of_day, :comment, :training_partner_ids, :day_attributes

  validates_presence_of :day_id, :author_id, :training_type

  after_validation :set_training_type_token_error

  def authorid; author.userid end

  def day_attributes=(params)
    self.day = params[:date].empty? ? nil : Day.find_or_create_by_date(params[:date]) 
  end

  def date; day.date end

  def training_type_name; training_type && training_type.name end

  def training_type_token
    training_type_id
  end
  def training_type_token=(token)
    self.training_type_id = TrainingType.id_from_token(token)
  end

  private

    def set_training_type_token_error
      errors.add(:training_type_token, I18n.t('errors.messages.blank')) if errors.messages[:training_type]
    end
end

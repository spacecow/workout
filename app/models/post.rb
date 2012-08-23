class Post < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :training_type

  has_many :trainingships
  has_many :training_partners, through: :trainingships, source: :partner

  attr_accessible :date, :distance, :duration, :time_of_day, :comment, :training_type_token, :training_partner_ids
  attr_reader :training_type_token

  validates_presence_of :date, :author_id, :training_type

  after_validation :set_training_type_token_error

  def authorid; author.userid end

  def training_type_name; training_type && training_type.name end

  def training_type_token=(token)
    self.training_type_id = TrainingType.id_from_token(token)
  end

  private

    def set_training_type_token_error
      errors.add(:training_type_token, I18n.t('errors.messages.blank')) if errors.messages[:training_type]
    end
end

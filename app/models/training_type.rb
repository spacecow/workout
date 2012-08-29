class TrainingType < ActiveRecord::Base
  has_many :posts

  has_many :typeships  
  has_many :posts, through: :typeships

  attr_accessible :name

  validates :name, presence:true, uniqueness:true

  class << self
    def ids_from_tokens(tokens)
      tokens.gsub!(/<<<(.+?)>>>/){ create!(name:$1).id}
      tokens.split(",")
    end

    def tokens(query)
      training_types = where("name like ?", "%#{query}%")
      if training_types.empty?
        [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
      else
        training_types
      end
    end
  end
end

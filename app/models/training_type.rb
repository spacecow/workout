class TrainingType < ActiveRecord::Base
  has_many :posts

  attr_accessible :name

  validate :name, presenece:true, uniqueness:true

  class << self
    def id_from_token(token)
      token.gsub!(/<<<(.+?)>>>/){ create!(name:$1).id}
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

class Typeship < ActiveRecord::Base
  belongs_to :post
  belongs_to :training_type

  attr_accessible :post_id, :training_type_id
end

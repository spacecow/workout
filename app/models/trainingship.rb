class Trainingship < ActiveRecord::Base
  belongs_to :post
  belongs_to :partner, :class_name => 'User'

  attr_accessible :partner_id, :post_id
end

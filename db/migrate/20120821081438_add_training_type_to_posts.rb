class AddTrainingTypeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :training_type_id, :integer
  end
end

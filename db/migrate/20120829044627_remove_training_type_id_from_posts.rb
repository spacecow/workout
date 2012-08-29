class RemoveTrainingTypeIdFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :training_type_id
  end

  def down
    add_column :posts, :training_type_id, :integer
  end
end

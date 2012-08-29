class CreateTypeships < ActiveRecord::Migration
  def change
    create_table :typeships do |t|
      t.integer :post_id
      t.integer :training_type_id

      t.timestamps
    end
  end
end

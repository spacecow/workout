class CreateTrainingships < ActiveRecord::Migration
  def change
    create_table :trainingships do |t|
      t.integer :post_id
      t.integer :partner_id

      t.timestamps
    end
  end
end

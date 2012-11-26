class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notifiable_id
      t.string :notifiable_type
      t.integer :creator_id
      t.integer :type_mask
      t.string :content

      t.timestamps
    end
  end
end

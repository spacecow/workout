class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.date :date
      t.datetime :time_of_day
      t.integer :distance
      t.integer :duration
      t.text :comment

      t.timestamps
    end
  end
end

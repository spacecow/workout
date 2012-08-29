class CreateTopentries < ActiveRecord::Migration
  def change
    create_table :topentries do |t|
      t.integer :score
      t.integer :duration
      t.integer :user_id
      t.integer :day_id

      t.timestamps
    end
  end
end

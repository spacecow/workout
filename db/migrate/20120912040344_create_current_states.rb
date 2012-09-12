class CreateCurrentStates < ActiveRecord::Migration
  def change
    create_table :current_states do |t|
      t.integer :day_id
      t.string :weight
      t.integer :user_id

      t.timestamps
    end
  end
end

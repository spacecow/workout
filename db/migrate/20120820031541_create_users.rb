class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :userid
      t.string :password_digest
      t.string :email
      t.integer :roles_mask

      t.timestamps
    end
  end
end

class AddFirstPostDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_post_date, :date
  end
end

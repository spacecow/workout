class AddDayIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :day_id, :integer
    remove_column :posts, :date
  end

  def self.down
    remove_column :posts, :day_id
    add_column :posts, :date, :date
  end
end

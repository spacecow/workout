class AddIntensityToPost < ActiveRecord::Migration
  def change
    add_column :posts, :intensity, :integer, :default => 5
  end
end

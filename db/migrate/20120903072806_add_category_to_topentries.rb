class AddCategoryToTopentries < ActiveRecord::Migration
  def change
    add_column :topentries, :category, :string
  end
end

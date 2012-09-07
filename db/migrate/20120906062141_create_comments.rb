class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :commentable, polymorphic:true
      t.integer :commenter_id
      #t.integer :commentable_id
      #t.string :commantable_type

      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end

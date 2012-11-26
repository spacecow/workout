class CreateNoticements < ActiveRecord::Migration
  def change
    create_table :noticements do |t|
      t.integer :user_id
      t.integer :notification_id
      t.boolean :unread, default:true

      t.timestamps
    end
  end
end

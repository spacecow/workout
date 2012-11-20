class AddNoteToCurrentStates < ActiveRecord::Migration
  def change
    add_column :current_states, :note, :text
  end
end

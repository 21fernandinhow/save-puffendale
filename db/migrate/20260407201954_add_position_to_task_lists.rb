class AddPositionToTaskLists < ActiveRecord::Migration[7.2]
  def change
    add_column :task_lists, :position, :integer, default: 0, null: false
    add_index :task_lists, [:user_id, :position]
  end
end

class BackfillTaskListPositions < ActiveRecord::Migration[7.2]
  def up
    TaskList.unscoped.order(:user_id, :created_at).group_by(&:user_id).each do |_user_id, lists|
      lists.each_with_index do |list, index|
        list.update_column(:position, index)
      end
    end
  end

  def down
    TaskList.unscoped.update_all(position: 0)
  end
end

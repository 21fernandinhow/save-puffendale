class SetDefaultMagicPointsForUsers < ActiveRecord::Migration[7.0]
  def up
    change_column_default :users, :magic_points, 0

    User.where(magic_points: nil).update_all(magic_points: 0)
  end

  def down
    change_column_default :users, :magic_points, nil
  end
end
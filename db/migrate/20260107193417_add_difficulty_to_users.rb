class AddDifficultyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :difficulty, :string
  end
end

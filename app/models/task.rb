class Task < ApplicationRecord
  belongs_to :task_list
  validates :name, presence: true
  attribute :completed, :boolean, default: false

  after_update :update_magic_points, if: :saved_change_to_completed?

  private

  def update_magic_points
    user = task_list.user
    if completed
      user.increment!(:magic_points, 10)
    else
      user.decrement!(:magic_points, 10)
    end
  end
  
end
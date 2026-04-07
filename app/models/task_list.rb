class TaskList < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(updated_at: :desc) }, dependent: :destroy

  validates :name, presence: true

  default_scope { order(position: :asc) }

  before_create :set_position

  private

  def set_position
    self.position = (user.task_lists.maximum(:position) || -1) + 1
  end
end
class TaskList < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(updated_at: :desc) }, dependent: :destroy

  validates :name, presence: true
end
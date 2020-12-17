class ShiftSeparation < ApplicationRecord
  belongs_to :master
  default_scope -> { order(start_time: :asc) }
  validates :name, presence: true, uniqueness: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
end

class Staff < ApplicationRecord
  belongs_to :master
  default_scope -> { order(created_at: :desc) }
  validates :master_id,    presence: true
  validates :staff_name,   presence: true
  validates :staff_number, presence: true
end

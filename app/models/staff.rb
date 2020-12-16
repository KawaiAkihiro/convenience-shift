class Staff < ApplicationRecord
  belongs_to :master
  default_scope -> { order(staff_number: :desc) }
  validates :master_id,    presence: true
  validates :staff_name,   presence: true
  validates :staff_number, presence: true

  has_secure_password
  validates :password,   presence: true, length: { minimum: 4}, allow_nil: true
end

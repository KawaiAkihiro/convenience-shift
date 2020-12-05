class Master < ApplicationRecord
    validates :store_name, presence: true, length: { maximum: 20}, uniqueness: true
    validates :user_name,  presence: true, length: { maximum: 20}

    has_secure_password
    validates :password,   presence: true, length: { minimum: 6}
end

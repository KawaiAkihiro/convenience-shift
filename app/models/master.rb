class Master < ApplicationRecord
    attr_accessor :remember_token 
    validates :store_name, presence: true, length: { maximum: 20}, uniqueness: true
    validates :user_name,  presence: true, length: { maximum: 20}

    has_secure_password
    validates :password,   presence: true, length: { minimum: 6}

    def Master.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end

    def Master.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = Master.new_token
        update_attribute(:remember_digest, Master.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end

class Customer < User

    has_secure_password

    validates :username, :password, presence: true
    validates :username, uniqueness: true

end
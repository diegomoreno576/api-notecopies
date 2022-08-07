class User < ApplicationRecord
  rolify
    has_secure_password
    has_many :messages, dependent: :destroy
    has_many :chatrooms, through: :messages
    has_many :blogs
  
    validates :username, :password, presence: true
    validates :username, uniqueness: true

    after_create :assign_default_role

    def assign_default_role
      self.add_role(:cliente) if self.roles.blank?
    end
  end
  
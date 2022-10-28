class User < ApplicationRecord
  rolify
    has_secure_password
    has_many :messages, dependent: :destroy
    has_many :chatrooms, through: :messages
    has_many :user_companies
    has_many :companies, through: :user_companies


    validates :username, :password, presence: true
    validates :username, uniqueness: true

    after_create :assign_default_role

    def assign_default_role
      self.add_role(:customer) if self.roles.blank?
    end
  end
  
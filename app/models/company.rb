class Company < ApplicationRecord
  has_many :user_companies
  has_many :users, through: :user_companies
  has_many :employes, through: :user_companies
  has_many :customers, through: :user_companies
  
  
  validates :code, uniqueness: true
end

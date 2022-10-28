class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  has_many :customers, through: :messages
  has_many :employes, through: :messages
  

  validates :title, uniqueness: true
end

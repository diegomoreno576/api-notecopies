class Brand < ApplicationRecord
  belongs_to :user
  has_many :connections
end

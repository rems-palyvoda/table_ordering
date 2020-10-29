class Table < ApplicationRecord
  belongs_to :restaurant

  has_many :reservations
  
  validates :restaurant, presence: true
end

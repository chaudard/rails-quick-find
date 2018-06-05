class Store < ApplicationRecord
  belongs_to :provider
  has_many :schedules
end

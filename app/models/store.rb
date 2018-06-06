class Store < ApplicationRecord
  belongs_to :provider
  has_many :schedules
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end

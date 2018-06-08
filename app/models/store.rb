class Store < ApplicationRecord
  belongs_to :provider, optional: true
  has_many :schedules
  validates :longitude, :uniqueness => {:scope => [:latitude, :name]}
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end

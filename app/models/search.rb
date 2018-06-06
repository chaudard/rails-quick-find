class Search < ApplicationRecord
  has_many :articles
  validates :keywords, presence: true
  validates :input_address, presence: true
  validates :distance, presence: true
  geocoded_by :input_address
  after_validation :geocode, if: :will_save_change_to_input_address?

  def self.distances
    [10, 25, 50, 75]
  end
end

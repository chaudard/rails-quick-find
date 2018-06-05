class Search < ApplicationRecord
  has_many :articles
  validates :keywords, presence: true
  validates :input_address, presence: true
  validates :distance, presence: true

  def self.distances
    [10, 25, 50, 75]
  end
end

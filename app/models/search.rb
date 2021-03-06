class Search < ApplicationRecord
  has_many :articles, dependent: :destroy
  validates :keywords, presence: true
  validates :input_address, presence: true
  validates :distance, presence: true
  geocoded_by :input_address
  after_validation :geocode, if: :will_save_change_to_input_address?

  def self.distances
    ["5", "10", "20", "50"].map { |d| OpenStruct.new(value: d, label: "#{d} km")}
  end

  #def address
    #self.input_address
  #end
end

class Article < ApplicationRecord
  belongs_to :search
  belongs_to :provider
  has_many :images
  has_many :stocks
end

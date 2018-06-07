class Article < ApplicationRecord
  belongs_to :search
  belongs_to :provider, optional: true
  has_many :images, dependent: :destroy
  has_many :stocks, dependent: :destroy
end

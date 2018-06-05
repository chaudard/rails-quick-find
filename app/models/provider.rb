class Provider < ApplicationRecord
  has_many :articles
  has_many :stores
end

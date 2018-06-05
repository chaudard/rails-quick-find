class Article < ApplicationRecord
  belongs_to :search
  belongs_to :provider
end

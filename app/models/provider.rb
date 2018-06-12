class Provider < ApplicationRecord
  has_many :articles
  has_many :stores

  def self.enseignes
    ["-","celio", "izac", "jules"] # '-' = pas de tri sur le prix
  end
end

class AddCityToSearches < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :city, :string
  end
end

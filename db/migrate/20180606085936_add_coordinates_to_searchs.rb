class AddCoordinatesToSearchs < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :latitude, :float
    add_column :searches, :longitude, :float
  end
end

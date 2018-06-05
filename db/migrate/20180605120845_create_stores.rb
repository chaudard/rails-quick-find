class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.float :latitude
      t.float :longitude
      t.references :provider, foreign_key: true

      t.timestamps
    end
  end
end

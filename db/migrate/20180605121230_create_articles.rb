class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :sku
      t.string :title
      t.string :description
      t.integer :price
      t.boolean :selected
      t.references :search, foreign_key: true
      t.references :provider, foreign_key: true

      t.timestamps
    end
  end
end

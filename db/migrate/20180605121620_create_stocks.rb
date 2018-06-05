class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :size
      t.boolean :available
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end

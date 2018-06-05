class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.string :keywords
      t.string :input_address
      t.integer :distance

      t.timestamps
    end
  end
end

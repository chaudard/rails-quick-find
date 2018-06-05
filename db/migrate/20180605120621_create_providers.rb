class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :base_url
      t.string :logo
      t.string :website

      t.timestamps
    end
  end
end

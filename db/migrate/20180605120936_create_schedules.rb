class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :name
      t.string :open_hours
      t.references :store, foreign_key: true

      t.timestamps
    end
  end
end

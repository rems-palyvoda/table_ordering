class CreateRestaurant < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.integer :start_working_time, null: false
      t.integer :end_working_time, null: false

      t.timestamps
    end
  end
end


class CreateLiteUniqueRiders < ActiveRecord::Migration[5.2]
  def change
    create_table :lite_unique_riders do |t|
      t.integer :year
      t.integer :num_unique_riders

      t.timestamps
    end
  end
end

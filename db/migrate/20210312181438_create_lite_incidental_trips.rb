class CreateLiteIncidentalTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :lite_incidental_trips do |t|
      t.date :trip_date
      t.integer :num_trips
      t.integer :total_mileage
      t.references :vehicle

      t.timestamps
    end
  end
end

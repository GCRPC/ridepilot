class CreateLiteTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :lite_trips do |t|
      t.date :trip_date
      t.integer :num_one_way_trips
      t.integer :num_senior_trips
      t.integer :num_disabled_trips
      t.references :vehicle
      t.integer :start_odometer
      t.integer :end_odometer
      t.integer :lift_odometer
      t.boolean :pre_trip_inspection

      t.timestamps
    end
  end
end

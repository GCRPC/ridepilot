class AddLiteProviderIdColumns < ActiveRecord::Migration[5.2]
  def change
    add_reference :lite_trips, :provider, default: 1, foreign_key: true, index: true
    add_reference :lite_incidental_trips, :provider, default: 1, foreign_key: true, index: true
    add_reference :lite_customers, :provider, default: 1, foreign_key: true, index: true
    add_reference :lite_unique_riders, :provider, default: 1, foreign_key: true, index: true
  end
end

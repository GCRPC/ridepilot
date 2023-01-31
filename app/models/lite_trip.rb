class LiteTrip < ApplicationRecord

  belongs_to :provider
  belongs_to :vehicle

  scope :for_date_range,     -> (from_date, to_date) { where(trip_date: from_date.beginning_of_day..(to_date - 1.day).end_of_day) }
  scope :for_provider,  -> (provider_id) { where(provider_id: provider_id) }
  scope :for_vehicle,            -> (vehicle_id) { where(vehicle_id: vehicle_id) }

end
class TripsLiteController < ApplicationController

  def index
    Date.beginning_of_week= :sunday

    @lite_trips = LiteTrip.joins(:vehicle).for_provider(current_provider_id).order('trip_date, vehicles.name')

    @lite_incidental_trips = LiteIncidentalTrip.for_provider(current_provider_id).order(:trip_date)
    @lite_customers = LiteCustomer.for_provider(current_provider_id).order(:last_name)
    @lite_customers = @lite_customers.paginate :page => params[:page], :per_page => 15

    @lite_trip = LiteTrip.for_provider(current_provider_id).first

    @lite_unique_rider = LiteUniqueRider.for_provider(current_provider_id).order(year: :desc).first
    if @lite_unique_rider
    else
      @lite_unique_rider = LiteUniqueRider.new(:provider_id => current_provider_id)
    end

    filter_trips

    @vehicles = Vehicle.where(:provider_id=>current_provider_id).default_order
    @start_pickup_date = Time.zone.at(session[:trips_start].to_i).to_date
    @end_pickup_date = Time.zone.at(session[:trips_end].to_i).to_date

    if @start_pickup_date > @end_pickup_date
      flash.now[:alert] = TranslationEngine.translate_text(:from_date_cannot_later_than_to_date)
    else
      flash.now[:alert] = nil
    end
  end

  def filter_trips
    filters_hash = params[:trip_filters] || {}

    update_sessions(filters_hash)

    trip_filter = LiteTripFilter.new(@lite_trips, trip_sessions)
    @lite_trips = trip_filter.filter!
    # need to re-update start&end filters
    # as default values are used if they were not presented initially
    update_sessions({
                      start: trip_filter.filters[:start],
                      end: trip_filter.filters[:end],
                      vehicle_id: trip_filter.filters[:vehicle_id]
                    })

    incidental_trip_filter = LiteTripFilter.new(@lite_incidental_trips, trip_sessions)
    @lite_incidental_trips = incidental_trip_filter.filter!
    # need to re-update start&end filters
    # as default values are used if they were not presented initially
    update_sessions({
                      start: trip_filter.filters[:start],
                      end: trip_filter.filters[:end],
                      vehicle_id: trip_filter.filters[:vehicle_id]
                    })

  end

  def update_sessions(params = {})
    params.each do |key, val|
      session["trips_#{key}"] = val if !val.nil?
    end
  end

  def trip_sessions
    {
      start: session[:trips_start],
      end: session[:trips_end],
      vehicle_id: session[:trips_vehicle_id]
    }
  end

end
class Lite::LiteTripsController < ApplicationController

  def index
    @lite_trips = LiteTrip.for_provider(current_provider_id)
  end

  def show
    @lite_trip = LiteTrip.find(params[:id])
  end

  def new
    @vehicles = Vehicle.where(:provider_id=>current_provider_id).default_order

    @lite_trip = LiteTrip.new(:provider_id => current_provider_id)
  end

  def create
    @lite_trip = LiteTrip.new(lite_trip_params)
    if !lite_trip_params[:trip_date].blank?
      begin
        @lite_trip.trip_date = Date.strptime(lite_trip_params[:trip_date], "%m/%d/%Y")
      rescue ArgumentError
        begin
          @lite_trip.trip_date = Date.strptime(lite_trip_params[:trip_date], "%b %d, %Y")
        rescue ArgumentError
        end
      end
    end

    if @lite_trip.save
      redirect_to trips_lite_index_path
    else
      render :new
    end
  end

  def edit
    @vehicles = Vehicle.where(:provider_id=>current_provider_id).default_order

    @lite_trip = LiteTrip.find(params[:id])
  end

  def update
    @lite_trip = LiteTrip.find(params[:id])

    lparams = lite_trip_params
    formatted_trip_date = Date.strptime(lparams["trip_date"], "%m/%d/%Y").strftime("%Y-%m-%d")
    lparams["trip_date"] = formatted_trip_date

    if @lite_trip.update(lparams)
      redirect_to trips_lite_index_path
    else
      render :edit
    end
  end

  def destroy
    @lite_trip = LiteTrip.find(params[:id])
    @lite_trip.destroy

    redirect_to trips_lite_index_path
  end

  private

    def lite_trip_params
      params.require(:lite_trip).permit(
        :id,
        :trip_date,
        :num_one_way_trips,
        :num_senior_trips,
        :num_disabled_trips,
        :vehicle_id,
        :start_odometer,
        :end_odometer,
        :lift_odometer,
        :pre_trip_inspection,
        :provider_id
      )
    end
end
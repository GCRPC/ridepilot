class Lite::LiteIncidentalTripsController < ApplicationController

  def index
    @lite_incidental_trips = LiteIncidentalTrip.for_provider(current_provider_id)
  end

  def show
    @lite_incidental_trip = LiteIncidentalTrip.find(params[:id])
  end

  def new
    @vehicles = Vehicle.where(:provider_id=>current_provider_id).default_order

    @lite_incidental_trip = LiteIncidentalTrip.new(:provider_id => current_provider_id)
  end

  def create
    @lite_incidental_trip = LiteIncidentalTrip.new(lite_incidental_trip_params)
    if !lite_incidental_trip_params[:trip_date].blank?
      begin
        @lite_incidental_trip.trip_date = Date.strptime(lite_incidental_trip_params[:trip_date], "%m/%d/%Y")
      rescue ArgumentError
        begin
          @lite_incidental_trip.trip_date = Date.strptime(lite_incidental_trip_params[:trip_date], "%b %d, %Y")
        rescue ArgumentError
        end
      end
    end

    if @lite_incidental_trip.save
      redirect_to trips_lite_index_path
    else
      render :new
    end
  end

  def edit
    @vehicles = Vehicle.where(:provider_id=>current_provider_id).default_order

    @lite_incidental_trip = LiteIncidentalTrip.find(params[:id])
  end

  def update
    @lite_incidental_trip = LiteIncidentalTrip.find(params[:id])

    lparams = lite_incidental_trip_params
    formatted_trip_date = Date.strptime(lparams["trip_date"], "%m/%d/%Y").strftime("%Y-%m-%d")
    lparams["trip_date"] = formatted_trip_date

    if @lite_incidental_trip.update(lparams)
      redirect_to trips_lite_index_path
    else
      render :edit
    end
  end

  def destroy
    @lite_incidental_trip = LiteIncidentalTrip.find(params[:id])
    @lite_incidental_trip.destroy

    redirect_to trips_lite_index_path
  end

  private

    def lite_incidental_trip_params
      params.require(:lite_incidental_trip).permit(
        :id,
        :trip_date,
        :num_trips,
        :total_mileage,
        :vehicle_id,
        :provider_id
      )
    end

end
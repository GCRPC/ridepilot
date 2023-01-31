class Lite::LiteUniqueRidersController < ApplicationController

  def index
    @lite_unique_riders = LiteUniqueRider.for_provider(current_provider_id)
  end

  def show
    @lite_unique_rider = LiteUniqueRider.find(params[:id])
  end

  def new
    @lite_unique_rider = LiteUniqueRider.new(:provider_id => current_provider_id)
  end

  def create
    @lite_unique_rider = LiteUniqueRider.new(lite_unique_rider_params)
    if lite_unique_rider_params[:year].blank?
      @lite_unique_rider.year = Date.today.year
    end

    if @lite_unique_rider.save
      redirect_to trips_lite_index_path
    else
      render :new
    end
  end

  def edit
    @lite_unique_rider = LiteUniqueRider.find(params[:id])
  end

  def update
    @lite_unique_rider = LiteUniqueRider.find(params[:id])
    if lite_unique_rider_params[:year].blank?
      @lite_unique_rider.year = Date.today.year
    end

    if @lite_unique_rider.update(lite_unique_rider_params)
      redirect_to trips_lite_index_path
    else
      render :edit
    end
  end

  def destroy
    @lite_unique_rider = LiteUniqueRider.find(params[:id])
    @lite_unique_rider.destroy

    redirect_to trips_lite_index_path
  end

  private

    def lite_unique_rider_params
      params.require(:lite_unique_rider).permit(
        :id,
        :year,
        :num_unique_riders,
        :provider_id
      )
    end

end
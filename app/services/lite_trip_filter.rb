class LiteTripFilter

  attr_reader :trips, :filters

  def initialize(trips, filters = {})
    @trips = trips
    @filters = filters
  end

  def filter!
    filter_by_trip_date!
    filter_by_vehicle!

    @trips
  end

  private 

  def filter_by_trip_date!
    utility = Utility.new
    t_start = utility.parse_date(@filters[:start]) 
    t_end = utility.parse_date(@filters[:end]) 
    
    if !t_start && !t_end
      first_of_month_time = Time.current.beginning_of_month
      time    = Time.current
      t_start = first_of_month_time.to_date.in_time_zone
      t_end   = time.to_date.in_time_zone
    elsif !t_end
      t_end   = t_start
    elsif !t_start
      t_start   = t_end
    end
    
    @trips = @trips.
      where("trip_date >= '#{t_start.beginning_of_day.utc.strftime "%Y-%m-%d"}'").
      where("trip_date <= '#{t_end.end_of_day.utc.strftime "%Y-%m-%d"}'").order(:trip_date)

    @filters[:start] = t_start.to_i
    @filters[:end] = t_end.to_i
  end

  def filter_by_vehicle!
    if @filters[:vehicle_id].present?  
      if @filters[:vehicle_id].to_i == -1
        @trips = @trips.where(cab: true)
      else
        @trips = @trips.where("vehicle_id": @filters[:vehicle_id])
      end
    end
  end

  def filter_by_customer!
    if @filters[:customer_id].present?  
      @trips = @trips.where("customer_id": @filters[:customer_id])
    end
  end

end
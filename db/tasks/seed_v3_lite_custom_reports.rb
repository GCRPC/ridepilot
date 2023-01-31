[
  {
    name: 'vehicle_5310_report',
    title: 'FTA 5310 Vehicle Report'
  },
  {
    name: 'one_way_trips_report',
    title: 'Total Number of One-Way Trips Report'
  },
  {
    name: 'vehicle_monthly_service_report',
    title: 'Vehicle Monthly Service Report'
  },
  {
    name: 'daily_report',
    title: 'Daily Report'
  },
  {
    name: 'incidental_trips_report',
    title: 'Incidental Trips Report'
  },
  {
    name: 'customer_totals_report',
    title: 'Customer Totals Report'
  },
  {
    name: 'unique_rider_totals_report',
    title: 'Unique Rider Totals Report'
  }].each do |report_data|
  report = CustomReport.where(name: report_data[:name], version: '3').first_or_create
  report.update(redirect_to_results: true, title: report_data[:title])
end
class Ride < Sequel::Model(:rides)
  def self.unfinished_rides
    with_sql(
      "select *
       from #{:rides} rr
       where rr.id not in
       ( select re.ride_id from #{:rides_end} re where re.ride_id = rr.id )"
    )
  end

  def self.ongoing_ride_for_driver(driver_id)
    with_sql(
      "select *
       from #{:rides} rr
       where driver_id = #{driver_id}
         and rr.id not in
       ( select re.ride_id from #{:rides_end} re where re.ride_id = rr.id )"
    ).first
  end
end

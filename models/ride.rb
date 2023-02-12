class Ride < Sequel::Model(:rides)
  def self.unfinished_rides
    with_sql(
      "select *
       from #{:rides} rr
       where rr.id not in
       ( select re.ride_id from #{:rides_end} re where re.ride_id = rr.id )"
    )
  end
end

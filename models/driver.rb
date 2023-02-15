class Driver < Sequel::Model(:drivers)
  def self.free_drivers
    urs = Ride.unfinished_rides.all.map(&:driver_id).join(', ')
    with_sql(
      "select *
       from #{:drivers} dr" +
      (urs.empty? ? '' : " where dr.id not in ( #{urs} )")
    )
  end
end

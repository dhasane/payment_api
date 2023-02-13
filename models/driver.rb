class Driver < Sequel::Model(:drivers)
  def self.free_drivers
    urs = Ride.unfinished_rides.all.map(&:driver_id).join(', ')
    with_sql(
      "select *
       from #{:drivers} dr" +
      (urs.empty? ? '' : " where dr.id not in ( #{urs} )")
    )
  end

  def self.on_drive(driver_id)
    urs = Ride.unfinished_rides.all.map(&:driver_id).join(', ')
    with_sql(
      "select *
       from #{:drivers} dr
       where dr.id = #{driver_id}" +
      (urs.empty? ? '' : " and dr.id not in ( #{urs} )")
    ).first
  end
end

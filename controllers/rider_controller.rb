class RiderController
  def payment(tcard)

  end

  def request_ride(rider_id, latitude, longitude)
    driver = DriverController.find_free_driver
    RideController.start_ride(rider_id, driver.id, latitude, longitude)
  end

  # nil if not on ride, ride_id if on drive
  def find_ongoing_ride(rider_id)
    od = Rider.on_drive(rider_id).first
    od.nil? ? nil : od.id
  end
end

class RiderController
  def payment(tcard)

  end

  def request_ride(rider_id, latitude, longitude)
    driver = DriverController.find_free_driver
    RideController.start_ride(rider_id, driver.id, latitude, longitude)
  end
end

require_relative './driver_controller'
require_relative './ride_controller'

class RiderController
  def self.request_ride(rider_id, latitude, longitude)
    driver = DriverController.find_free_driver
    RideController.start_ride(rider_id, driver.id, latitude, longitude)
  end

  def self.get_user_id(rider_id)
    rider = Rider.where(id: rider_id).first

    if !rider.nil?
      User.where(id: rider.user_id).first.id
    end
  end
end

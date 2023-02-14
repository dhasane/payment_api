require_relative '../models/driver'

class DriverController
  def find_free_driver
    Driver.free_drivers.first
  end

  # nil if not on ride, ride_id if on drive
  def find_ongoing_ride(driver_id)
    od = Driver.on_drive(driver_id).first
    od.nil? ? nil : od.id
  end
end

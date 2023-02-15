require_relative '../models/driver'

class DriverController
  def find_free_driver
    Driver.free_drivers.first
  end
end

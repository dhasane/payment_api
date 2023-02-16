require_relative '../models/driver'

class DriverController
  def self.find_free_driver
    Driver.free_drivers.first
  end
end

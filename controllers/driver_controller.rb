require '../models/driver'

class DriverController
  def create_transaction
    PaymentsAPI.createTransaction()
  end

  def find_free_driver
    Driver.free_drivers.first
  end
end

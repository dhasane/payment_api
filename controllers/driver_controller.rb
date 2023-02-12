require '../models/driver'
require '../models/ride'
class DriverController
  def calculate_fee(ride_id)
    r_start = Ride.where(id: ride_id)
    r_end = RideEnd.where(id: ride_id)

    time = (r_end.end_time - r_start.start_time).minutes

    distance = r_end.distance

    # 1000 each km
    # 200 each minute
    # 3500 base fee
    distance * 1000 + time * 200 + 3500
  end

  def create_transaction
    PaymentsAPI.createTransaction()
  end
end

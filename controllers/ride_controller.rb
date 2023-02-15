require 'matrix'
require_relative '../models/ride'
require_relative '../models/ride_end'

class RideController
  def self.start_ride(rider_id, driver_id, latitude, longitude)
    Ride.insert(
      rider_id: rider_id,
      driver_id: driver_id,
      start_time: Time.now,
      latitude: latitude,
      longitude: longitude
    )
  end

  def self.end_ride(ride_id, latitude, longitude)
    RideEnd.insert(
      ride_id: ride_id,
      end_time: Time.now,
      latitude: latitude,
      longitude: longitude
    )
  end

  def self.ride_ended(ride_id)
    !RideEnd.where(ride_id: ride_id).first.nil?
  end

  def self.calculate_fee(ride_id)
    r_start = Ride.where(id: ride_id).first
    r_end = RideEnd.where(ride_id: ride_id).first

    # time in minutes
    time = Integer((r_end.end_time - r_start.start_time) / 60)

    # calculated as if flat coordinates
    puts "#{r_start.latitude}  #{r_start.longitude}"
    puts "#{r_end.latitude}    #{r_end.longitude}"

    distance = (Vector[r_start.latitude, r_start.longitude] - Vector[r_end.latitude, r_end.longitude]).magnitude
    puts distance

    # 1000 each km
    # 200 each minute
    # 3500 base fee
    distance * 1000 + time * 200 + 3500
  end

  def self.find_ongoing_ride_for_driver(driver_id)
    Ride.ongoing_ride_for_driver(driver_id)
  end
end

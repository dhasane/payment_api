require 'timecop'
require 'minitest/autorun'
require_relative '../db_helper'
require_relative '../../controllers/ride_controller'

class RideControllerTest < Minitest::Test
  def setup
    # @ = Driver.new
    user_id = User.insert
    @driver_id = Driver.insert(user_id: user_id)
    user_id = User.insert
    @rider_id = Rider.insert(user_id: user_id)
  end

  def test_start_ride
    ride_id = RideController.start_ride(@rider_id, @driver_id, 1, 1)

    assert_equal @rider_id, Ride.where(id: ride_id).first.rider_id
    assert_equal @driver_id, Ride.where(id: ride_id).first.driver_id
  end

  def test_end_ride
    ride_id = RideController.start_ride(@rider_id, @driver_id, 1, 1)

    assert_nil RideEnd.where(ride_id: ride_id).first

    RideController.end_ride(ride_id, 2, 2)

    assert RideController.ride_ended(ride_id)
  end

  def test_calculate_fee
    minutes = 30

    ride_id = RideController.start_ride(@rider_id, @driver_id, 1, 1)

    Timecop.freeze(Time.now + minutes * 60) do
      RideController.end_ride(ride_id, 1, 101)
    end

    fee = RideController.calculate_fee(ride_id)

    expected_fee = (100 * 1000 + minutes * 200 + 3500) * 1000

    assert_equal expected_fee, fee
  end

  def test_ongoing_ride
    ride_id = RideController.start_ride(@rider_id, @driver_id, 1, 1)

    ride_ongoing_id = RideController.find_ongoing_ride_for_driver(@driver_id).id

    assert_equal ride_id, ride_ongoing_id

    RideController.end_ride(ride_id, 1, 2)
  end
end

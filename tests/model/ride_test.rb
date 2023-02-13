require 'minitest/autorun'
require_relative './db_helper'

class RideDBTest < Minitest::Spec
  def test_driver_empty
    assert_equal 0, Ride.count
  end

  def test_insert_ride_no_river_driver
    user_id = User.insert
    driver_id = Driver.insert(user_id: user_id)
    user_id = User.insert
    rider_id = Rider.insert(user_id: user_id)

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(rider_id: rider_id)
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(driver_id: driver_id)
    end

    assert_equal 0, Ride.count

    Ride.insert(driver_id: driver_id, rider_id: rider_id)

    assert_equal 1, Ride.count
  end

  def test_insert_ride
    user_id = User.insert
    driver_id = Driver.insert(user_id: user_id)
    user_id = User.insert
    rider_id = Rider.insert(user_id: user_id)
    ride_id = Ride.insert(driver_id: driver_id, rider_id: rider_id, latitude: 0, longitude: 0)

    assert_nil Driver.on_drive(driver)

    assert_equal 1, Ride.count

    assert_equal ride_id, Driver.on_drive(driver)

    assert_equel ride_id, Ride.where(rider_id: rider_id, driver_id: driver_id)
  end
end

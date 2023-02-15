require 'minitest/autorun'
require_relative '../db_helper'

class RideDBTest < Minitest::Spec
  def test_insert_ride_no_river_driver
    baseline = Ride.count

    user_id = User.insert
    driver_id = Driver.insert(user_id: user_id)
    user_id = User.insert
    rider_id = Rider.insert(user_id: user_id)

    longitude = 1
    latitude = 1

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(rider_id: rider_id)
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(driver_id: driver_id)
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(driver_id: driver_id, rider_id: rider_id)
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(driver_id: driver_id, rider_id: rider_id, latitude: latitude)
    end

    assert_raises Sequel::NotNullConstraintViolation do
      Ride.insert(driver_id: driver_id, rider_id: rider_id, longitude: longitude)
    end

    assert_equal baseline, Ride.count

    Ride.insert(driver_id: driver_id, rider_id: rider_id, latitude: latitude, longitude: longitude)

    assert_equal baseline + 1, Ride.count
  end

  def test_insert_ride
    baseline = Ride.count

    user_id = User.insert
    driver_id = Driver.insert(user_id: user_id)
    user_id = User.insert
    rider_id = Rider.insert(user_id: user_id)

    assert_nil Ride.ongoing_ride_for_driver(driver_id)

    ride_id = Ride.insert(driver_id: driver_id, rider_id: rider_id, latitude: 0, longitude: 0)

    assert_equal baseline + 1, Ride.count

    assert_equal ride_id, Ride.ongoing_ride_for_driver(driver_id).id

    assert_equal ride_id, Ride.where(rider_id: rider_id, driver_id: driver_id).reverse(:id).first.id
  end
end

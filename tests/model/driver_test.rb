require 'minitest/autorun'
require_relative '../db_helper'

class DriverDBTest < Minitest::Spec
  def test_free_drivers
    baseline = Driver.free_drivers.count
    assert_equal baseline, Driver.free_drivers.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
  end

  def test_insert_driver_no_user
    assert_raises Sequel::NotNullConstraintViolation do
      Driver.insert
    end
  end

  def test_insert_driver
    baseline = Driver.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal baseline + 1, Driver.count
  end

  def test_insert_multiple_drivers
    baseline = Driver.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal baseline + 1, Driver.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal baseline + 2, Driver.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal baseline + 3, Driver.count
  end
end

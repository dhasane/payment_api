require 'minitest/autorun'
require_relative './db_helper'

class DriverDBTest < Minitest::Spec
  def test_driver_empty
    assert_equal 0, Driver.count
  end

  def test_no_drivers_free
    assert_equal 0, Driver.free_drivers.count
  end

  def test_insert_driver_no_user
    assert_raises Sequel::NotNullConstraintViolation do
      Driver.insert
    end
  end

  def test_insert_driver
    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal 1, Driver.count
  end

  def test_insert_multiple_drivers
    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal 1, Driver.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal 2, Driver.count

    user_id = User.insert
    Driver.insert(user_id: user_id)
    assert_equal 3, Driver.count
  end
end

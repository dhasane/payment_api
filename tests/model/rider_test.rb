require 'minitest/autorun'
require_relative './db_helper'

class RiderDBTest < Minitest::Spec
  def test_driver_empty
    assert_equal 0, Rider.count
  end

  def test_no_drivers_free
    assert_equal 0, Rider.free_drivers.count
  end

  def test_insert_driver_no_user
    assert_raises Sequel::NotNullConstraintViolation do
      Rider.insert
    end
  end

  def test_insert_driver
    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal 1, Rider.count
  end

  def test_insert_multiple_drivers
    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal 1, Rider.count

    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal 2, Rider.count

    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal 3, Rider.count
  end
end

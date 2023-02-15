require 'minitest/autorun'
require_relative '../db_helper'

class RiderDBTest < Minitest::Spec
  def test_insert_driver_no_user
    assert_raises Sequel::NotNullConstraintViolation do
      Rider.insert
    end
  end

  def test_insert_driver
    baseline = Rider.count

    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal baseline + 1, Rider.count
  end

  def test_insert_multiple_drivers
    baseline = Rider.count

    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal baseline + 1, Rider.count

    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal baseline + 2, Rider.count

    user_id = User.insert
    Rider.insert(user_id: user_id)
    assert_equal baseline + 3, Rider.count
  end
end

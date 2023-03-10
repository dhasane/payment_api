class CreateTables < Sequel::Migration
  def up
    # this would have all common user info
    create_table :users do
      primary_key :id
    end

    create_table :riders do
      primary_key :id
      Integer :user_id, null: false

      foreign_key [:user_id], :users, name: 'fk_rider_to_user'
    end

    create_table :drivers do
      primary_key :id, unique: true
      Integer :user_id, null: false

      float :latitude
      float :longitude

      foreign_key [:user_id], :users, name: 'fk_driver_to_user'
    end

    create_table :rides do
      primary_key :id
      Integer :rider_id, null: false
      Integer :driver_id, null: false
      DateTime :start_time

      float :latitude, null: false
      float :longitude, null: false

      foreign_key [:rider_id], :riders, name: 'fk_ride_to_rider'
      foreign_key [:driver_id], :drivers, name: 'fk_ride_to_driver'
    end

    create_table :rides_end do
      Integer :ride_id, unique: true, null: false
      DateTime :end_time

      float :latitude, null: false
      float :longitude, null: false

      foreign_key [:ride_id], :rides, name: 'fk_ride_end_to_ride'
    end

    create_table :payments do
      primary_key :id

      String :reference, null: false
      String :transaction_id, null: false
      Integer :user_id, null: false
      Integer :ride_id, null: false

      foreign_key [:user_id], :users, name: 'fk_payment_to_user'
      foreign_key [:ride_id], :rides, name: 'fk_payment_to_rides'
    end
  end

  def down
    drop_table :payments
    drop_table :rides_end
    drop_table :rides
    drop_table :drivers
    drop_table :riders
    drop_table :users
  end
end

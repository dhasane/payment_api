require_relative '.env'
begin
  require_relative '.secrets'
rescue LoadError
end

require 'sequel/core'

# Delete PAYMENT_API_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  PAYMENT_API_DATABASE_URL may contain passwords.
# DB = Sequel.connect(ENV.delete('PAYMENT_API_DATABASE_URL') || ENV.delete('DATABASE_URL'))
DB = Sequel.connect(
  adapter: 'postgres',
  host: 'localhost',
  database: ENV['PAYMENT_API_DATABASE'],
  user: 'postgres',
  password: 'Password'
)

# Load Sequel Database/Global extensions here
# DB.extension :date_arithmetic
DB.extension :pg_auto_parameterize if DB.adapter_scheme == :postgres && Sequel::Postgres::USES_PG

# definition for tables, still not completely sure about this

DB.create_table? :users do
  primary_key :id
  String :tkCC
end

DB.create_table? :riders do
  primary_key :id
end

DB.create_table? :drivers do
  primary_key :id, unique: true
  float :latitude
  float :longitude
end

DB.create_table? :rides do
  primary_key :id
  Integer :rider_id, null: false
  Integer :driver_id, null: false
  DateTime :start_time

  float :latitude, null: false
  float :longitude, null: false

  foreign_key [:rider_id], :riders, name: 'fk_ride_to_rider'
  foreign_key [:driver_id], :drivers, name: 'fk_ride_to_driver'
end

DB.create_table? :rides_end do
  Integer :ride_id, unique: true, null: false
  DateTime :end_time

  float :latitude, null: false
  float :longitude, null: false

  foreign_key [:ride_id], :rides, name: 'fk_ride_end_to_ride'
end

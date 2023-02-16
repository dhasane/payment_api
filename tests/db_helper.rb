require 'database_cleaner/sequel'
ENV['RACK_ENV'] = 'test'
require_relative '../models'
raise "test database doesn't end with test" if DB.opts[:database] && !DB.opts[:database].end_with?('test')

require 'sequel'
DatabaseCleaner.strategy = :transaction

# migrate = lambda do |env, version|
#   ENV['RACK_ENV'] = env
#   require 'logger'
#   Sequel.extension :migration
#   DB.loggers << Logger.new($stdout) if DB.loggers.empty?
#   Sequel::Migrator.apply(DB, '../migrate', version)
# end
#
# # task :version do
# #   require_relative 'db'
# #   version = if DB.tables.include?(:schema_info)
# #               DB[:schema_info].first[:version]
# #             end || 0
# #
# #   puts "Schema Version: #{version}"
# # end
#
# migrate.call('test', nil)

# TODO: find how to do this without replicating the table definitions

DB.create_table :users do
  primary_key :id
  String :tkCC
end

DB.create_table :riders do
  primary_key :id
  Integer :user_id, null: false

  foreign_key [:user_id], :users, name: 'fk_rider_to_user'
end

DB.create_table :drivers do
  primary_key :id, unique: true
  Integer :user_id, null: false

  float :latitude
  float :longitude

  foreign_key [:user_id], :users, name: 'fk_driver_to_user'
end

DB.create_table :rides do
  primary_key :id
  Integer :rider_id, null: false
  Integer :driver_id, null: false
  DateTime :start_time

  float :latitude, null: false
  float :longitude, null: false

  foreign_key [:rider_id], :riders, name: 'fk_ride_to_rider'
  foreign_key [:driver_id], :drivers, name: 'fk_ride_to_driver'
end

DB.create_table :rides_end do
  Integer :ride_id, unique: true, null: false
  DateTime :end_time

  float :latitude, null: false
  float :longitude, null: false

  foreign_key [:ride_id], :rides, name: 'fk_ride_end_to_ride'
end

DB.create_table :payments do
  String :reference, null: false
  String :transaction_id, null: false
  Integer :user_id, null: false
  Integer :ride_id, null: false

  foreign_key [:user_id], :users, name: 'fk_payment_to_user'
  foreign_key [:ride_id], :rides, name: 'fk_payment_to_rides'
end

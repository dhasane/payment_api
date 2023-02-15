require 'database_cleaner/sequel'
ENV['RACK_ENV'] = 'test'
require_relative '../models'
raise "test database doesn't end with test" if DB.opts[:database] && !DB.opts[:database].end_with?('test')

# create the database on memory
# require_relative '../../db'
# require 'logger'
# Sequel.extension :migration
# DB.loggers << Logger.new($stdout) if DB.loggers.empty?
# Sequel::Migrator.apply(DB, '../../migrate', 0)

# test_helper.rb
DatabaseCleaner.strategy = :transaction

# DatabaseCleaner.clean

# class Minitest::Test
  # before :each do
    # DatabaseCleaner.start
  # end
#
  # after :each do
    # DatabaseCleaner.clean
  # end
# end

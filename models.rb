require_relative 'db'
require 'sequel/model'

if ENV['RACK_ENV'] == 'development'
  Sequel::Model.cache_associations = false
end

Sequel::Model.plugin :auto_validations
Sequel::Model.plugin :require_valid_schema
Sequel::Model.plugin :subclasses unless ENV['RACK_ENV'] == 'development'

unless defined?(Unreloader)
  require 'rack/unreloader'
  Unreloader = Rack::Unreloader.new(reload: false, autoload: !ENV['NO_AUTOLOAD'])
end

Unreloader.autoload('models') { |f| Sequel::Model.send(:camelize, File.basename(f).sub(/\.rb\z/, '')) }

if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'test'
  require 'logger'
  LOGGER = Logger.new($stdout)
  LOGGER.level = Logger::FATAL if ENV['RACK_ENV'] == 'test'
  DB.loggers << LOGGER
end

# less than ideal, these values will be created each time the app runs

user_id = DB[:users].insert
DB[:riders].insert(user_id: user_id)

(0..50).step do
  user_id = DB[:users].insert
  DB[:drivers].insert(user_id: user_id)
end

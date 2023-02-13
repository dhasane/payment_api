ENV["RACK_ENV"] = 'test'
require_relative '../../models'
raise "test database doesn't end with test" if DB.opts[:database] && !DB.opts[:database].end_with?('test')

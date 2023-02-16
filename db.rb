require_relative '.env'
begin
  require_relative '.secrets'
rescue LoadError
end

require 'sequel/core'

DB = if ENV['RACK_ENV'] == 'test'
       Sequel.sqlite
     else
       Sequel.connect(
         adapter: 'postgres',
         host: 'localhost',
         database: ENV['PAYMENT_API_DATABASE'],
         user: 'postgres',
         password: 'Password'
       )
     end

if ENV['RACK_ENV'] == 'test'
  puts 'test migration'
  Sequel.extension :migration
  Sequel::Migrator.apply(DB, 'migrate')
end

# Load Sequel Database/Global extensions here
# DB.extension :date_arithmetic
DB.extension :pg_auto_parameterize if DB.adapter_scheme == :postgres && Sequel::Postgres::USES_PG

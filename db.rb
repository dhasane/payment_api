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

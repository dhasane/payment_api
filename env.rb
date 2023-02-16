begin
  require_relative '.secrets'
rescue LoadError
end

case ENV['RACK_ENV'] ||= 'development'
when 'test'
  ENV['PAYMENT_API_DATABASE'] ||= 'payment_api_test'
when 'production'
  ENV['PAYMENT_API_DATABASE'] ||= 'payment_api_production'
else
  ENV['PAYMENT_API_DATABASE'] ||= 'payment_api_development'
end

case ENV['RACK_ENV'] ||= 'development'
when 'test'
  ENV['PAYMENT_API_DATABASE'] ||= 'payment_api_production'
when 'production'
  ENV['PAYMENT_API_DATABASE'] ||= 'payment_api_test'
else
  ENV['PAYMENT_API_DATABASE'] ||= 'payment_api_development'
end

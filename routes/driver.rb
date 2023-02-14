require_relative '../controllers/driver_controller'
require_relative '../controllers/ride_controller'

class PaymentAPI
  hash_branch('driver') do |r|
    # /prefix1 branch handling
    r.on Integer do |driver_id|
      # /driver/on_ride
      r.on 'on_ride' do
        r.get do
          puts "Someone said #{@greeting}!"
          { on_ride: DriverController.find_ongoing_ride(driver_id) }.to_json
        end
      end

      # /driver/finish_ride
      r.on 'finish_ride' do
        r.post do
          ride_id = DriverController.find_ongoing_ride(driver_id)
          RideController.end_ride(ride_id) unless ride_id.nil?
        end
      end
    end
  end
end

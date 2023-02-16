require_relative '../controllers/driver_controller'
require_relative '../controllers/ride_controller'

class PaymentAPI
  hash_branch('driver') do |r|
    r.on Integer do |driver_id|
      r.on 'on_ride' do
        r.get do # POST /driver/:driver_id/on_ride
          ride = RideController.find_ongoing_ride_for_driver(driver_id)
          { on_ride: ride.nil? ? nil : ride.id }.to_json
        end
      end

      r.on 'finish_ride' do # POST /driver/:driver_id/finish_ride
        r.post do
          b = JSON.parse(r.body.read)
          ride = RideController.find_ongoing_ride_for_driver(driver_id)

          ended = false
          unless ride.nil?
            RideController.end_ride(
              ride.id,
              b['latitude'],
              b['longitude']
            )
            ended = true
          end

          {
            on_ride: !ride.nil?,
            ride_ended: ended
          }.to_json
        end
      end
    end
  end
end

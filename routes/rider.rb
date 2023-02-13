require_relative "../controllers/rider_controller"

class PaymentAPI
  hash_branch('rider') do |r|
    puts 'on rider'
    r.on Integer do |rider_id|
      # # puts rider_id
      r.is 'on_ride' do
        r.get do
          puts "Someone said #{@greeting}!"
          # TODO: return if rider is in a ride
          { on_ride: 0 }.to_json
        end
      end
      # /rider/pay
      r.on 'pay' do
        r.post do
          puts "Someone said #{@greeting}!"
          # TODO: create payment mehthod
          r.redirect
        end
        r.get do
          puts "test said #{@greeting}!"
          # TODO: create payment mehthod
          'test'
        end
      end

      r.on 'request_ride' do
        r.on Integer, Integer do |latitude, longitude|
          # maybe change thiis, so it's sent as the body
          r.post do
            RiderController.request_ride(rider_id, latitude, longitude)
            r.redirect
          end
        end
      end
    end
  end
end

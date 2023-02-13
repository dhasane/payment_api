require_relative '../controllers/driver_controller'

class PaymentAPI
  hash_branch('driver') do |r|
    # /prefix1 branch handling
    puts 'on driver branch'
    r.on ':driver_id' do |driver_id|
      puts driver_id
      # /driver/on_ride
      r.on 'on_ride' do
        r.get do
          puts "Someone said #{@greeting}!"
          # TODO: return if driver is in a ride
          { on_ride: 0 }.to_json
        end
      end

      # /driver/finish_ride
      r.on 'finish_ride' do
        r.post do
          # TODO: check if driver is in a ride
          # TODO: end ride
          r.redirect
        end
      end
    end
  end
end

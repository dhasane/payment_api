class PaymentAPI
  hash_branch('rider') do |r|
    # puts rider_id
    r.on 'on_ride' do
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
      r.post do
        puts "Someone said #{@greeting}!"
        # TODO: Assign driver
        # TODO: Start ride
        r.redirect
      end
    end
  end
end

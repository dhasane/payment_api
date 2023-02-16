require_relative '../controllers/rider_controller'
require_relative '../controllers/payments_controller'
require 'pp'

class PaymentAPI
  hash_branch('rider') do |r|
    puts 'in rider'
    r.on Integer do |rider_id|
      b = JSON.parse(r.body.read)
      r.on Integer do |ride_id|
        r.on 'pay' do # POST /rider/:rider_id/:ride_id/pay
          r.post do
            {
              payment_id: PaymentsController.create_transaction(
                rider_id,
                b['card_token'],
                ride_id,
                b['accept_habeas_data']
              )
            }.to_json
          end

          r.get do # GET /rider/:rider_id/:ride_id
            { transaction_state: PaymentsController.check_transaction(b['payment_id']) }.to_json
          end
        end
      end

      r.on 'request_ride' do # POST /rider/:rider_id/request_ride
        r.post do
          { ride_id: RiderController.request_ride(rider_id, b['latitude'], b['longitude']) }.to_json
        end
      end
    end
  end
end

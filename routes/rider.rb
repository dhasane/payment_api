require_relative '../controllers/rider_controller'
require_relative '../controllers/payments_controller'

def json_reqs_missing(json, reqs)
  if reqs.map { |n| json.key?(n) }.all?
    nil
  else
    reqs.join(', ')
  end
end

class PaymentAPI
  hash_branch('rider') do |r|
    r.on Integer do |rider_id|
      b = JSON.parse(r.body.read)
      r.on Integer do |ride_id|
        r.on 'pay' do # POST /rider/:rider_id/:ride_id/pay
          r.post do
            reqs = ['card_token', 'accept_habeas_data']
            missing = json_reqs_missing(b, reqs)
            if missing.nil?
              {
                payment_id: PaymentsController.create_transaction(
                  rider_id,
                  b['card_token'],
                  ride_id,
                  b['accept_habeas_data']
                )
              }.to_json
            else
              { error: "request should contain fields: #{missing} " }.to_json
            end
          end

          r.get do # GET /rider/:rider_id/:ride_id/pay
            reqs = ['payment_id']
            missing = json_reqs_missing(b, reqs)
            if missing.nil?
              { transaction_state: PaymentsController.check_transaction(b['payment_id']) }.to_json
            else
              { errors: "request should contain fields: #{missing} " }.to_json
            end
          end
        end
      end

      r.on 'request_ride' do # POST /rider/:rider_id/request_ride
        r.post do
          reqs = ['latitude', 'longitude']
          missing = json_reqs_missing(b, reqs)
          if missing.nil?
            { ride_id: RiderController.request_ride(rider_id, b['latitude'], b['longitude']) }.to_json
          else
            { errors: "request should contain fields: #{missing} " }.to_json
          end
        end
      end
    end
  end
end

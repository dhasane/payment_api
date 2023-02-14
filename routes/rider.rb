require_relative "../controllers/rider_controller"
require_relative "../controllers/payments_controller"

class PaymentAPI
  hash_branch('rider') do |r|
    r.on Integer do |rider_id|
      # /rider/pay
      r.on Integer do |ride_id|
        r.on 'pay' do
          r.post do
            b = r.body
            {
              transaction_id: PaymentsController.create_transaction(
                b.user_id,
                b.card_token,
                RideController.calculate_fee(ride_id),
                b.accept_habeas_data
              )
            }.to_json
          end

          r.get do
            { transaction_state: PaymentsController.check_transaction }.to_json
          end
        end
      end

      r.on 'request_ride' do
        r.post do
          b = r.body
          RiderController.request_ride(rider_id, b.latitude, b.longitude)
        end
      end
    end
  end
end

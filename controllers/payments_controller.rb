require_relative '../external/payments_gateway'
require_relative './rider_controller'

class PaymentsController
  def self.create_transaction(rider_id, token, ride_id, accept_habeas_data)
    return unless accept_habeas_data

    user_id = RiderController.get_user_id(rider_id)
    fee = RideController.calculate_fee(ride_id)

    puts "fee #{fee}"
    reference = "payments-api-#{user_id}-#{Time.now.strftime('%d-%m-%Y-%H-%M-%S')}"
    transaction = PaymentsGateway.create_transaction(reference, token, fee, accept_habeas_data)

    puts transaction
    unless transaction.key?('error')
      Payment.insert(
        reference: reference,
        transaction_id: transaction['data']['id'],
        user_id: user_id,
        ride_id: ride_id
      )
    end
  end

  def self.check_transaction(transaction_id)
    payment = Payment.where(id: transaction_id).first
    PaymentsGateway.check_transaction(payment.transaction_id)
  end
end

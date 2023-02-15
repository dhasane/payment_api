require 'http'
require_relative '../.env'
require_relative '../external/payments_gateway'
# require_relative '../models/payments'
begin
  require_relative '../.secrets'
rescue LoadError
end

class PaymentsController
  def self.create_transaction(user_id, token, amount, accept_habeas_data)
    return unless accept_habeas_data

    reference = "payments-api-#{user_id}-#{Time.now.strftime('%d-%m-%Y-%H-%M-%S')}"
    transaction = PaymentsGateway.create_transaction(reference, token, amount, accept_habeas_data)

    unless transaction.key?('error')
      Payment.insert(
        reference: reference,
        transaction_id: transaction['data']['id'],
        user_id: user_id
      )
    end
  end

  def self.check_transaction(transaction_id)
    payment = Payment.where(id: transaction_id).first
    PaymentsGateway.check_transaction(payment.transaction_id)
  end
end

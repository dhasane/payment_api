require 'http'
require_relative '../.env'
# require_relative '../models/payments'
begin
  require_relative '../.secrets'
rescue LoadError
end

class PaymentsController
  @acceptance_token = nil

  def self.post(endpoint, body)
    # this should be moved to secrets
    uri = ENV['PAYMENT_URL'] + endpoint
    puts uri
    req = HTTP.auth("Bearer #{ENV['PUBLIC_KEY']}")
              .post(uri,
                    json: body)
    JSON.parse(req)
  end

  def self.get(endpoint)
    # this should be moved to secrets
    uri = ENV['PAYMENT_URL'] + endpoint
    puts uri
    req = HTTP.auth("Bearer #{ENV['PUBLIC_KEY']}")
              .get(uri)
    JSON.parse(req)
  end

  def self.acceptance_token
    if @acceptance_token.nil?
      at = get("/merchants/#{ENV['PUBLIC_KEY']}")
      @acceptance_token = at['data']['presigned_acceptance']['acceptance_token']
    end

    @acceptance_token
  end

  def self.create_transaction(user_id, token, amount, accept_habeas_data)
    return unless accept_habeas_data

    reference = "payments-api-#{user_id}-#{Time.now.strftime('%d-%m-%Y-%H-%M-%S')}"
    body = {
      amount_in_cents: amount,
      currency: 'COP',
      reference: reference,
      customer_email: 'example@gmail.co',
      acceptance_token: acceptance_token,
      payment_method: {
        type: 'CARD',
        installments: 1,
        token: token
      }
    }
    # TODO: i still dont understand how this describes the end user for whom the money will go to
    tr_id = post('/transactions', body)

    unless tr_id.key?('error')
      Payment.insert(
        reference: reference,
        transaction_id: tr_id['data']['id'],
        user_id: user_id
      )
    end
  end

  def self.check_transaction(transaction_id)
    payment = Payment.where(id: transaction_id).first
    puts payment
    get("/transactions/#{payment.transaction_id}")['data']['status']
  end
end

require_relative '../.env'
require_relative './http_utils'
begin
  require_relative '../.secrets'
rescue LoadError
end

class PaymentsGateway
  @acceptance_token = nil

  def self.acceptance_token
    if @acceptance_token.nil?
      act_tkn = HttpUtil.get("#{ENV['PAYMENT_URL']}/merchants/#{ENV['PUBLIC_KEY']}", ENV['PUBLIC_KEY'])
      @acceptance_token = act_tkn['data']['presigned_acceptance']['acceptance_token']
    end

    @acceptance_token
  end

  def self.create_transaction(reference, token, amount, accept_habeas_data)
    return unless accept_habeas_data

    body = {
      amount_in_cents: amount,
      currency: 'COP',
      reference: reference,
      customer_email: 'example@gmail.co', # TODO: this could be added to the user table
      acceptance_token: acceptance_token,
      payment_method: {
        type: 'CARD',
        installments: 1,
        token: token
      }
    }
    # TODO: i still dont understand how this describes the end user for whom the money will go to
    HttpUtil.post("#{ENV['PAYMENT_URL']}/transactions", ENV['PUBLIC_KEY'], body)
  end

  def self.check_transaction(transaction_id)
    HttpUtil.get("#{ENV['PAYMENT_URL']}/transactions/#{transaction_id}", ENV['PUBLIC_KEY'])['data']['status']
  end
end

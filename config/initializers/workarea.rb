Workarea.configure do |config|
  config.orderbot = ActiveSupport::Configurable::Configuration.new
  config.orderbot.api_timeout = 10
  config.orderbot.open_timeout = 10


  config.orderbot.transaction_id = {
    'ActiveMerchant::Billing::BogusGateway' => -> (transaction) { transaction.response.authorization },
    'ActiveMerchant::Billing::StripeGateway' => -> (transaction) { transaction.params['id'] },
    'ActiveMerchant::Billing::BraintreeBlueGateway' => -> (transaction) { transaction.response.params["braintree_transaction"]["order_id"] },
    'ActiveMerchant::Billing::MonerisGateway' => -> (transaction) { transaction.response.params["trans_id"] },
    'ActiveMerchant::Billing::AuthorizeNetCimGateway' => -> (transaction) { transaction.response.params["direct_response"]["transaction_id"] },
    'ActiveMerchant::Billing::CyberSourceGateway' => -> (transaction) { transaction.response.params["reasonCode"] },
    'ActiveMerchant::Billing::CheckoutV2Gateway' => -> (transaction) { transaction.response.params["id"]   }
  }
end

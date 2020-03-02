require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/orderbot/engine'
require 'workarea/orderbot/version'

require 'workarea/orderbot/bogus_gateway'
require 'workarea/orderbot/authentication'
require 'workarea/orderbot/gateway'
require 'workarea/orderbot/response'

module Workarea
  module Orderbot
    def self.config
      Workarea.config.orderbot
    end

    def self.api_user_name
      Workarea.config.orderbot_api_email_address
    end

    def self.api_password
      Workarea.config.orderbot_api_password
    end

    def self.api_configured?
      api_user_name.present? && api_password.present?
    end

    def self.test?
      Workarea.config.use_orderbot_staging_environment
    end

    def self.gateway
      if Rails.env.test?
        Orderbot::BogusGateway.new
      else
        Orderbot::Gateway.new(api_user_name: api_user_name, api_password: api_password, test: test?)
      end
    end
  end
end

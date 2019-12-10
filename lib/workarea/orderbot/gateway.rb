module Workarea
  module Orderbot
    class Gateway
      include Orderbot::Authentication
      attr_reader :options

      def initialize(options = {})
        requires!(options, :api_user_name, :api_password)
        @options = options
      end

      def get_products(attrs = {})
        response = connection.get do |req|
          req.options.params_encoder = Faraday::FlatParamsEncoder
          req.url "products"
          req.params = attrs
        end
        Orderbot::Response.new(response)
      end

      def get_inventory(attrs = {})
        response = connection.get do |req|
          req.options.params_encoder = Faraday::FlatParamsEncoder
          req.url "inventory"
          req.params = attrs
        end
        Orderbot::Response.new(response)
      end

      def create_order(attrs = {})
        response = connection.post do |req|
          req.url "orders"
          req.body = attrs.to_json
        end

        Orderbot::Response.new(response)
      end

      private

      def connection
        headers = {
          "Content-Type"  => "application/json",
          "Accept"        => "application/json",
          'Authorization' => "Bearer #{token}"
        }

        request_timeouts = {
          timeout: Workarea.config.orderbot[:api_timeout],
          open_timeout: Workarea.config.orderbot[:open_timeout]
        }

        Faraday.new(url: rest_endpoint, headers: headers, request: request_timeouts)
      end


      def rest_endpoint
        "https://api-beta.orderbot.com"
      end

      def requires!(hash, *params)
        params.each do |param|
          if param.is_a?(Array)
            raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first)

            valid_options = param[1..-1]
            raise ArgumentError.new("Parameter: #{param.first} must be one of #{valid_options.to_sentence(words_connector: 'or')}") unless valid_options.include?(hash[param.first])
          else
            raise ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param)
          end
        end
      end
    end
  end
end

module Workarea
  module Orderbot
    module Authentication
      def token
        response = get_token

        body = JSON.parse(response.body)
        body['token']
      end

      private

      def get_token
        conn = Faraday.new(url: rest_endpoint)
        conn.basic_auth(api_user_name, api_password)
        conn.get do |req|
          req.url '/accesstoken'
          req.headers['Content-Type'] = 'application/json'
        end
      end

      def api_user_name
        options[:api_user_name]
      end

      def api_password
        options[:api_password]
      end
    end
  end
end

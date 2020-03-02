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
        Rails.cache.fetch(token_cache_key, expires_in: 5.minutes) do
          conn = Faraday.new(url: rest_endpoint)
          conn.basic_auth(api_user_name, api_password)
          conn.get do |req|
            req.url '/accesstoken'
            req.headers['Content-Type'] = 'application/json'
          end
        end
      end

      def api_user_name
        options[:api_user_name]
      end

      def api_password
        options[:api_password]
      end

      def test
        options[:test]
      end

      def token_cache_key
        Digest::MD5.hexdigest "#{api_user_name}#{api_password}#{test}"
      end
    end
  end
end

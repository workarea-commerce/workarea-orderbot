module Workarea
  module Orderbot
    class Response
      def initialize(response)
        @response = response
      end

      def success?
        @response.success?
      end

      def body
        @body ||= JSON.parse(@response.body)
      end

      def headers
        @headers ||= @response.headers
      end

      def total_pages
        headers["x-total-pages"]
      end
    end
  end
end

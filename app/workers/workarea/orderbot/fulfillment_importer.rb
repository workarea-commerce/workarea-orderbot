module Workarea
  module Orderbot
    class FulfillmentImporter
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(options = {})
        return unless Orderbot.api_configured?

        Orderbot::ImportLog.log('fulfillment')  do |last_imported_at|
          from_updated_on = options[:from_updated_on] || last_imported_at

          fulfillment_filters = {
            shipped_on_min:  from_updated_on.iso8601
          }

          fulfillment_response = gateway.get_fulfillments(fulfillment_filters)
          raise 'get fulfillment error' unless  fulfillment_response.success?

          import_fulfillment_records(fulfillment_response.body)

          if fulfillment_response.total_pages.to_i > 1
            count = 2

            while count <= fulfillment_response.total_pages.to_i
              page_filters = fulfillment_filters.merge(page: count)
              response = gateway.get_products(page_filters)

              import_fulfillment_records(response.body)

              count = count + 1
            end
          end
        end
      end

      private

      def gateway
        Workarea::Orderbot.gateway
      end

      def import_fulfillment_records(fulfillment_records)
        fulfillment_records.each do |fulfillment|
          Orderbot::Fulfillment::ImportFulfillments.new.perform(fulfillment)
        end
      end
    end
  end
end

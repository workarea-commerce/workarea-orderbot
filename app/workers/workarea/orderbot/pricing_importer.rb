module Workarea
  module Orderbot
    class PricingImporter
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(options = {})
        return unless Orderbot.api_configured?

        Orderbot::ImportLog.log('pricing')  do |last_imported_at|
          last_import = options[:from_updated_on] || last_imported_at

          pricing_filters = {
            response_model:  "OrderGuideProduct",
            active: true
          }

          pricing_response = gateway.get_pricing(pricing_filters)

          raise 'get pricing error' unless  pricing_response.success?

          pricing_records = pricing_response.body

          write_prices(pricing_records, last_import)
          if pricing_response.total_pages.to_i > 1
            count = 2

            while count <= pricing_response.total_pages.to_i
              page_filters = pricing_filters.merge(page: count)
              response = gateway.get_products(page_filters)

              write_prices(response.body, last_import)
              count = count + 1
            end
          end

          Workarea::Orderbot::Pricing::ImportPricing.new.perform
        end
      end

      private

      def gateway
        Workarea::Orderbot.gateway
      end

      def write_prices(order_guides, last_update_threshold)
        order_guides.each do | order_guide|

          order_guide_id = order_guide["order_guide_id"]

          # only import the prices if we care about this order guide ID
          next if order_guide_id != Workarea.config.default_order_guide_id

          products = order_guide["products"]

          products.each do |product|

            next if product["last_updated_on"].present? && Time.parse(product["last_updated_on"]).iso8601 < last_update_threshold.in_time_zone(Workarea.config.orderbot_api_timezone).iso8601

            Orderbot::PricingImportData.create!(
              order_guide_id: order_guide_id,
              pricing_data: product
            )
          end
        end
      end
    end
  end
end

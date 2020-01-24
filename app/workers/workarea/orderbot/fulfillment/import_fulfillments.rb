module Workarea
  module Orderbot
    module Fulfillment
      class ImportFulfillments
        include Sidekiq::Worker

        def perform(attrs = {})
          fulfillment_data = attrs.deep_symbolize_keys
          order_id = fulfillment_data[:reference_id]

          order = Workarea::Order.find(order_id)
          fulfillment = Workarea::Fulfillment.find(order_id)

          fulfillment_data[:packages].each do |package|
            ship_package(package, order, fulfillment)
          end
        end

        private

        def ship_package(package, order, fulfillment)
          tracking_number = package[:tracking_number]

          items = package[:items].map do |item|
            order_item_id = order.items.detect { |oi| oi.sku = item[:sku] }.id.to_s
            {
              id: order_item_id,
              quantity: item[:quantity],
              orderbot_package_id: item[:package_id]
            }
          end
          fulfillment.ship_items(tracking_number, items)
        end
      end
    end
  end
end

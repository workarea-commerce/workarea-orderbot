require 'test_helper'

module Workarea
  module Orderbot
    class Fulfillment::ImportfulFillmentTest < TestCase
      def test_import_fulfillment
        order = create_placed_order

        fulfillment_data = {
          order_id: "123456789",
          reference_id: "1234",
          purchase_order: "00984",
          ship_date: "2020-01-17T20:26:50.889Z",
          carrier_service_type: "USPS Priority",
          ship_code: "FED",
          packages: [
            {
              package_id: "3003216",
              tracking_number: "1Z999AA10123456784",
              items: [
                {
                  package_item_id: "3003216",
                  product_id: "3003217",
                  sku: "SKU",
                  quantity: "2"
                }
              ]
            }
          ]
        }

        Workarea::Orderbot::Fulfillment::ImportFulfillments.new.perform(fulfillment_data)

        fulfillment = Workarea::Fulfillment.find(order.id)

        assert_equal(:shipped, fulfillment.status)
        assert_equal(1, fulfillment.events.size)
      end
    end
  end
end

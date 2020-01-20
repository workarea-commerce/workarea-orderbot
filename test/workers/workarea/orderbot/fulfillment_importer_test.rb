require 'test_helper'

module Workarea
  module Orderbot
    class ImportfulFillmentTest < TestCase
      def test_fulfillment_importer
        create_placed_order(id: '1234')
        create_placed_order(id: '4567')

        Workarea.config.orderbot_api_email_address = "test@workarea.com"
        Workarea.config.orderbot_api_password = "foobar"

        assert_equal(0, Workarea::Orderbot::ImportLog.count)

        Workarea::Orderbot::FulfillmentImporter.new.perform # uses Workarea::Orderbot::BogusGateway

        full_ship = Workarea::Fulfillment.find('1234')
        partial_ship = Workarea::Fulfillment.find('4567')

        assert(:shipped, full_ship.status)
        assert(:partially_shipped, partial_ship.status)

        log = Workarea::Orderbot::ImportLog.where(importer: "fulfillment").first
        assert(log.started_at.present?)
        assert(log.finished_at.present?)
      end
    end
  end
end

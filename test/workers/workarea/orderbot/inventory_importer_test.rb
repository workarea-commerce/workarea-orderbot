require 'test_helper'

module Workarea
  module Orderbot
    class ImportInventoryTest < TestCase
      def test_inventory_importer
        Workarea.config.orderbot_api_email_address = "test@workarea.com"
        Workarea.config.orderbot_api_password = "foobar"

        assert_equal(0, Workarea::Orderbot::ImportLog.count)

        Workarea::Orderbot::InventoryImporter.new.perform # uses Workarea::Orderbot::BogusGateway
        assert_equal(4, Workarea::Inventory::Sku.count)

        log = Workarea::Orderbot::ImportLog.where(importer: "inventory").first
        assert(log.started_at.present?)
        assert(log.finished_at.present?)
      end
    end
  end
end

require 'test_helper'

module Workarea
  class Orderbot::PricingImporterTest < TestCase
    def test_pricing_import_data
      Workarea.config.orderbot_api_email_address = "test@workarea.com"
      Workarea.config.orderbot_api_password = "foobar"
      Workarea.config.default_order_guide_id = 1

      assert_equal(0, Workarea::Orderbot::ImportLog.count)

      Workarea::Orderbot::PricingImporter.new.perform # uses data from Workarea::Orderbot::Bogusgateway

      assert_equal(3, Workarea::Pricing::Sku.count)

      sale_sku = Workarea::Pricing::Sku.find('SALE1')
      assert(sale_sku.on_sale?)

      price = sale_sku.prices.first

      assert_equal(45.00.to_m, price.regular)
      assert_equal(30.00.to_m, price.sale)

      log = Workarea::Orderbot::ImportLog.where(importer: "pricing").first
      assert(log.started_at.present?)
      assert(log.finished_at.present?)
    end
  end
end

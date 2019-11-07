require 'test_helper'

module Workarea
  class Orderbot::ProductImporterTest < TestCase
    def test_product_import_data
      Workarea.config.orderbot_api_email_address = "test@workarea.com"
      Workarea.config.orderbot_api_password = "foobar"

      assert_equal(0, Workarea::Orderbot::ImportLog.count)

      Workarea::Orderbot::ProductImporter.new.perform # uses data from Workarea::Orderbot::Bogusgateway

      assert_equal(0, Orderbot::ProductImportData.count)
      assert_equal(2, Workarea::Catalog::Product.count)
      assert_equal(3, Workarea::Pricing::Sku.count)
      assert_equal(3, Workarea::Shipping::Sku.count)

      log = Workarea::Orderbot::ImportLog.where(importer: "product").first
      assert(log.started_at.present?)
      assert(log.finished_at.present?)
    end
  end
end

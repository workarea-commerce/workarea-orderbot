require 'test_helper'

module Workarea
  module Orderbot
    class Inventory::ImportInventoryTest < TestCase
      def test_import_price
        pricing_data = {
          force_schedule: nil,
          last_updated_on: 5.minutes.ago,
          original_price: 15.0,
          price: 15.0,
          product_id: 3592532,
          sales_end_on: nil,
          sales_start_on: nil,
          sku: "SAMEPRICE1"
        }

        Orderbot::PricingImportData.create!(
          order_guide_id: 1,
          pricing_data: pricing_data
        )

        Workarea::Orderbot::Pricing::ImportPricing.new.perform
        sku = Workarea::Pricing::Sku.first
        price = sku.prices.first

        assert_equal(15.to_m, price.regular)
        refute(price.sale.present?)
        refute(price.on_sale?)
        refute(sku.on_sale?)
      end

      def test_import_sales_price
        pricing_data = {
          force_schedule: nil,
          last_updated_on: 5.minutes.ago,
          original_price: 15.0,
          price: 10.0,
          product_id: 3592532,
          sales_end_on: nil,
          sales_start_on: nil,
          sku: "SALEPRICE1"
        }

        Orderbot::PricingImportData.create!(
          order_guide_id: 1,
          pricing_data: pricing_data
        )

        Workarea::Orderbot::Pricing::ImportPricing.new.perform
        sku = Workarea::Pricing::Sku.first
        price = sku.prices.first

        assert_equal(15.to_m, price.regular)
        assert_equal(10.to_m, price.sale)
        assert(price.on_sale?)
        assert(sku.on_sale?)
      end
    end
  end
end

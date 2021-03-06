require 'test_helper'

module Workarea
  module Orderbot
    module Product
      class ParentProductTest < Workarea::TestCase
        def test_process
          parent_product = create_parent_product

          Orderbot::ParentProduct.new(parent_product).process

          product = Workarea::Catalog::Product.first
          assert_equal("Blue Tooth USB", product.name)
          assert_equal("Test", product.description)
          assert_equal("Electronics", product.filters[:orderbot_category])
          assert_equal("Accessories", product.filters[:orderbot_group])
          assert_equal(["BTUSB001"], product.fetch_detail(:upc))
          assert_equal("generic", product.template)

          parent_product.update_attributes!(
            product_data: {
            product_id: 3166006,
            name: "Blue Tooth USB",
            sku: "BTUSB01",
            upc: "BTUSB001",
            active: true,
            taxable: true,
            base_price: 1,
            orderguide_price: nil,
            units_of_measure: "Each",
            weight: 1,
            shipping_unit_of_measure: "Lbs",
            has_children: true,
            parent_id: 0,
            class_type: "Sales Items",
            group_id: 20693,
            group: "Accessories",
            category: "Electronics",
            first_variable_value: nil,
            second_variable_value: nil,
            descriptive_title: "",
            description: "NEW DESCRIPTION",
            other_info: "",
            creation_date: nil,
            last_updated: "2019-04-02T13:10:03.29",
            updated_by: 282517,
            workarea_info: {
              template: "ob_test",
              purchase_start_date: nil,
              purchase_end_date: nil
              }
            }
          )

          Workarea.config.product_templates = [:ob_test]

          Orderbot::ParentProduct.new(parent_product).process
          product.reload
          assert_equal(1, Workarea::Catalog::Product.count)
          assert_equal("NEW DESCRIPTION", product.description)
          assert_equal("ob_test", product.template)
        end

        private

        def create_parent_product
          product_attrs = {
            product_id: 3166006,
            name: "Blue Tooth USB",
            sku: "BTUSB01",
            upc: "BTUSB001",
            active: true,
            taxable: true,
            base_price: 1,
            orderguide_price: nil,
            units_of_measure: "Each",
            weight: 1,
            shipping_unit_of_measure: "Lbs",
            has_children: true,
            parent_id: 0,
            class_type: "Sales Items",
            group_id: 20693,
            group: "Accessories",
            category_id: 5462,
            category: "Electronics",
            first_variable_value: nil,
            second_variable_value: nil,
            descriptive_title: "",
            description: "Test",
            other_info: "",
            creation_date: nil,
            last_updated: "2019-04-02T13:10:03.29",
            updated_by: 282517,
            workarea_info: {
              template: "",
              purchase_start_date: nil,
              purchase_end_date: nil
            }
          }

          Orderbot::ProductImportData.create!(product_data: product_attrs)
        end
      end
    end
  end
end

require 'test_helper'

module Workarea
  module Orderbot
    module Product
      class ChildProductTest < Workarea::TestCase
        setup :create_import_products

        def test_process
          Orderbot::ParentProduct.new(@parent_product).process
          Orderbot::ChildProduct.new(@child_product).process

          product = Workarea::Catalog::Product.first
          pricing = Workarea::Pricing::Sku.first
          shipping = Workarea::Shipping::Sku.first

          assert_equal(1, product.variants.size)

          variant = product.variants.first
          assert_equal("BTUSB01", variant.sku)
          assert_equal("Blue Tooth USB BLUE", variant.name)
          assert(variant.details.present?)

          assert_equal(1, pricing.prices.size)
          assert_equal(50.to_m, pricing.sell_price)

          assert_equal(16, shipping.weight) # 1lb converted to oz.
          assert_equal([1, 2, 3], shipping.dimensions)
          product.reload

          assert_equal(["Red", "Pink"], product.filters["color"])
          assert_equal(["cotton", "metal"], product.filters["material"])
          assert_equal("Electronics", product.filters[:orderbot_category])
          assert_equal("Accessories", product.filters[:orderbot_group])
        end

        def test_process_orderguide_price
          Orderbot::ParentProduct.new(@parent_product).process
          Orderbot::ChildProduct.new(@order_guide_price_product).process

          pricing = Workarea::Pricing::Sku.first

          assert_equal(1, pricing.prices.size)
          assert_equal(40.to_m, pricing.sell_price)
        end

        def test_process_no_sku
          Orderbot::ParentProduct.new(@parent_product).process

          assert_raise Workarea::Orderbot::ChildProduct::ChildProductImportError do
            Orderbot::ChildProduct.new(@no_sku_child_product).process
          end
        end

        def test_process_no_parent_product
          assert_raise Workarea::Orderbot::ChildProduct::NoParentProductImportError do
            Orderbot::ChildProduct.new(@child_product).process
          end
        end

        private

        def create_import_products
          product_attrs = {
            product_id: 3166006,
            name: "Blue Tooth USB",
            sku: nil,
            upc: "BTUSB001",
            active: true,
            taxable: true,
            base_price: 1,
            orderguide_price: nil,
            units_of_measure: "Each",
            shipping_weight: 1,
            shipping_weight_measurement_unit: "Lbs",
            has_children: true,
            parent_id: 0,
            class_type: "Sales Items",
            group_id: 20693,
            group: "Accessories",
            category_id: 5462,
            category: "Electronics",
            first_variable: {
              group: "phone color",
              type: "color",
              value: "Red"
            },
            second_variable: {
              group: "material",
              type: "material",
              value: "cotton"
            },
            descriptive_title: "",
            description: "Test",
            other_info: "",
            creation_date: nil,
            last_updated: "2019-04-02T13:10:03.29",
            updated_by: 282517,
            shipping_height: 1,
            shipping_width: 2,
            shipping_length: 3,
            workarea_info: {
              template: "",
              purchase_start_date: nil,
              purchase_end_date: nil
            }
          }

          @parent_product = Orderbot::ProductImportData.create!(product_data: product_attrs)

          child_product_attrs = {
            product_id: 3166007,
            name: "Blue Tooth USB BLUE",
            sku: "BTUSB01",
            upc: "BTUSB00122",
            active: true,
            taxable: true,
            base_price: 50,
            orderguide_price: nil,
            units_of_measure: "Each",
            shipping_weight: 1,
            shipping_weight_measurement_unit: "Lbs",
            has_children: true,
            parent_id: 3166006,
            class_type: "Sales Items",
            group_id: 20693,
            group: "Accessories",
            category_id: 5462,
            category: "Electronics",
            first_variable: {
              group: "phone colors",
              type: "color",
              value: "Pink"
            },
            second_variable: {
              group: "material",
              type: "material",
              value: "metal"
            },
            descriptive_title: "",
            description: "Test",
            other_info: "",
            creation_date: nil,
            last_updated: "2019-04-02T13:10:03.29",
            updated_by: 282517,
            shipping_height: 1,
            shipping_width: 2,
            shipping_length: 3,
            workarea_info: {
              template: "",
              purchase_start_date: nil,
              purchase_end_date: nil
            }
          }

          @child_product = Orderbot::ProductImportData.create!(parent_product_id: 3166006, product_data: child_product_attrs)

          order_guide_product_attrs = {
            product_id: 3166007,
            name: "Blue Tooth USB BLUE",
            sku: "BTUSB01",
            upc: "BTUSB00122",
            active: true,
            taxable: true,
            base_price: 50,
            orderguide_price: 40,
            units_of_measure: "Each",
            shipping_weight: 1,
            shipping_weight_measurement_unit: "Lbs",
            has_children: true,
            parent_id: 3166006,
            class_type: "Sales Items",
            group_id: 20693,
            group: "Accessories",
            category_id: 5462,
            category: "Electronics",
            first_variable: {
              group: "phone colors",
              type: "color",
              value: "Pink"
            },
            second_variable: {
              group: "material",
              type: "material",
              value: "metal"
            },
            descriptive_title: "",
            description: "Test",
            other_info: "",
            creation_date: nil,
            last_updated: "2019-04-02T13:10:03.29",
            updated_by: 282517,
            shipping_height: 1,
            shipping_width: 2,
            shipping_length: 3,
            workarea_info: {
              template: "",
              purchase_start_date: nil,
              purchase_end_date: nil
            }
          }

          @order_guide_price_product = Orderbot::ProductImportData.create!(parent_product_id: 3166006, product_data: order_guide_product_attrs)

          no_sku_child_product_attrs = {
            product_id: 3166008,
            name: "Blue Tooth USB BLUE",
            sku: nil,
            upc: "BTUSB00122",
            active: true,
            taxable: true,
            base_price: 50,
            orderguide_price: nil,
            units_of_measure: "Each",
            shipping_weight: 1,
            shipping_weight_measurement_unit: "Lbs",
            has_children: true,
            parent_id: 3166006,
            class_type: "Sales Items",
            group_id: 20693,
            group: "Accessories",
            category_id: 5462,
            category: "Electronics",
            first_variable: {
              group: "Phone Colors",
              type: "color",
              value: "Pink"
            },
            second_variable: {
              group: "material",
              type: "material",
              value: "metal"
            },
            descriptive_title: "",
            description: "Test",
            other_info: "",
            creation_date: nil,
            last_updated: "2019-04-02T13:10:03.29",
            updated_by: 282517,
            shipping_height: 1,
            shipping_width: 2,
            shipping_length: 3,
            workarea_info: {
              template: "",
              purchase_start_date: nil,
              purchase_end_date: nil
            }
          }

          @no_sku_child_product = Orderbot::ProductImportData.create!(parent_product_id: 3166006, product_data: no_sku_child_product_attrs)
        end
      end
    end
  end
end

module Workarea
  module Orderbot
    class BogusGateway
      def initialize(options = {})
      end

      def get_products(attrs = {})
        if attrs[:response_model] == 'CustomField' && attrs[:sku] == 'backordersku'
          Response.new(response(get_backordered_products_custom_field_response))
        elsif attrs[:response_model] == 'CustomField'
          Response.new(response(get_products_custom_field_response))
        else
          Response.new(response(get_products_response))
        end
      end

      def get_inventory(attrs = {})
        Response.new(response(get_inventory_response))
      end

      def get_pricing(attrs = {})
        Response.new(response(get_pricing_response))
      end

      def create_order(attrs = {})
        if attrs.first[:reference_order_id] == "error"
          Response.new(response(create_error_order_response, 400))
        else
          Response.new(response(create_order_response))
        end
      end

      def get_fulfillments(attrs = {})
        Response.new(response(get_fulfillments_response))
      end

      private

      def response(body, status = 200)
        response = Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get("/orders/createorder") { |env| [ status, {}, body.to_json ] }
          end
        end
        response.get("/orders/createorder")
      end

      def get_products_custom_field_response
        [
          {
          product_id: 123456,
          custom_fields: [
              {
                  name: "Product Batch",
                  value: "123"
              },
              {
                  name: "Dye Type",
                  value: "abc"
              },
              {
                  name: "Grade",
                  value: "F minus"
              },
              {
                  name: "MFG Color",
                  value: "baby boi blue"
              },
              {
                  name: "backorderable",
                  value: false
              }
            ]
          }
        ]
      end

      def get_backordered_products_custom_field_response
        [
          {
          product_id: 123456,
          custom_fields: [
              {
                  name: "backorderable",
                  value: true
              }
            ]
          }
        ]
      end

      def get_products_response
        [
          {
            category: "Electronics",
            group: "Phone",
            product_id: 3212905,
            sku: "APP0008",
            name: "iPhone 6M Pink Soft",
            has_children: false,
            parent_id: 2548672,
            parent_sku: "APP0001",
            measurement_unit: "Each",
            taxable: true,
            gst_only: false,
            first_variable: {
                group: "Colour",
                type: "Phone",
                value: "Pink"
                },
            second_variable: {
                group: "Texture",
                type: "Density",
                value: "Soft"
                },
            description: "",
            other_important_info: "",
            upc: "",
            active: true,
            reference_product: nil,
            base_price: 600,
            order_in_multiples: 1,
            shipping_weight: 2,
            shipping_weight_measurement_unit: "Oz",
            apply_shipping_fee: true,
            location: "",
            maximum_commission_rate: 0,
            export_hts: "",
            country: nil,
            descriptive_title: "",
            csr_description: "",
            meta_keywords: "",
            workarea_info: {
                template: "",
                purchase_start_date: nil,
                purchase_end_date: nil
                },
            shopify_info: {
                published_scope: "none",
                inventory_management: false
                },
            shipping_length: nil,
            shipping_height: nil,
            shipping_width: nil,
            digital: false,
            created_on: "2018-07-04T13:53:12.133",
            updated_on: 1.day.ago
          },
          {
            category: "Electronics",
            group: "Phone",
            product_id: 3212904,
            sku: "APP0009",
            name: "iPhone 6M Pink HD",
            has_children: false,
            parent_id: 2548672,
            parent_sku: "APP0001",
            measurement_unit: "Each",
            taxable: true,
            gst_only: false,
            first_variable: {
                group: "Colour",
                type: "Phone",
                value: "Pink"
                },
            second_variable: {
                group: "Texture",
                type: "Density",
                value: "Hard"
                },
            description: "",
            other_important_info: "",
            upc: "",
            active: true,
            reference_product: nil,
            base_price: 600,
            order_in_multiples: 1,
            shipping_weight: 2,
            shipping_weight_measurement_unit: "Oz",
            apply_shipping_fee: true,
            location: "",
            maximum_commission_rate: 0,
            export_hts: "",
            country: nil,
            descriptive_title: "",
            csr_description: "",
            meta_keywords: "",
            workarea_info: {
                template: "",
                purchase_start_date: nil,
                purchase_end_date: nil
                },
            shopify_info: {
                published_scope: "none",
                inventory_management: false
                },
            shipping_length: nil,
            shipping_height: nil,
            shipping_width: nil,
            digital: false,
            created_on: "2018-07-04T13:53:11.803",
            updated_on: 1.day.ago
          },
          {
            category: "Electronics",
            group: "Phone",
            product_id: 2855051,
            sku: "APP0011",
            name: "iPhone 6M Blue Soft",
            has_children: false,
            parent_id: 2548672,
            parent_sku: "APP0001",
            measurement_unit: "Each",
            taxable: true,
            gst_only: false,
            first_variable: {
                group: "Colour",
                type: "Phone",
                value: "Blue"
                },
            second_variable: {
                group: "Texture",
                type: "Density",
                value: "Soft"
                },
            description: "",
            other_important_info: "",
            upc: "",
            active: true,
            reference_product: nil,
            base_price: 600,
            order_in_multiples: 1,
            shipping_weight: 2,
            shipping_weight_measurement_unit: "Oz",
            apply_shipping_fee: true,
            location: "",
            maximum_commission_rate: 0,
            export_hts: "",
            country: nil,
            descriptive_title: "",
            csr_description: "",
            meta_keywords: "",
            workarea_info: {
                template: "",
                purchase_start_date: nil,
                purchase_end_date: nil
                },
            shopify_info: {
                published_scope: "none",
                inventory_management: false
                },
            shipping_length: nil,
            shipping_height: nil,
            shipping_width: nil,
            digital: false,
            created_on: "2017-08-03T16:44:52.04",
            updated_on: 1.day.ago
          },
          {
            category: "Electronics",
            group: "Phone",
            product_id: 2550254,
            sku: "NK0001",
            name: "Nokia 150",
            has_children: true,
            parent_id: 0,
            parent_sku: nil,
            measurement_unit: "Each",
            taxable: true,
            gst_only: false,
            first_variable: {
                group: nil,
                type: nil,
                value: nil
                },
            second_variable: {
                group: nil,
                type: nil,
                value: nil
                },
            description: "",
            other_important_info: "",
            upc: "NK001001",
            active: true,
            reference_product: nil,
            base_price: 650,
            order_in_multiples: 1,
            shipping_weight: 1,
            shipping_weight_measurement_unit: "Lbs",
            apply_shipping_fee: true,
            location: "",
            maximum_commission_rate: 8,
            export_hts: "",
            country: nil,
            descriptive_title: "",
            csr_description: "",
            meta_keywords: "",
            workarea_info: {
                template: "",
                purchase_start_date: nil,
                purchase_end_date: nil
                },
            shopify_info: {
                published_scope: "none",
                inventory_management: nil
                },
            shipping_length: nil,
            shipping_height: nil,
            shipping_width: nil,
            digital: false,
            created_on: "2016-12-23T10:36:16.637",
            updated_on: 1.day.ago
          },
          {
            category: "Electronics",
            group: "Phone",
            product_id: 2548672,
            sku: "APP0001",
            name: "iPhone 6M",
            has_children: true,
            parent_id: 0,
            parent_sku: nil,
            measurement_unit: "Each",
            taxable: true,
            gst_only: false,
            first_variable: {
                group: nil,
                type: nil,
                value: nil
                },
            second_variable: {
                group: nil,
                type: nil,
                value: nil
                },
            description: "",
            other_important_info: "",
            upc: "APP001001",
            active: true,
            reference_product: nil,
            base_price: 600,
            order_in_multiples: 1,
            shipping_weight: 2,
            shipping_weight_measurement_unit: "Oz",
            apply_shipping_fee: true,
            location: "",
            maximum_commission_rate: nil,
            export_hts: "",
            country: nil,
            descriptive_title: "",
            csr_description: "",
            meta_keywords: "",
            workarea_info: {
                template: "",
                purchase_start_date: nil,
                purchase_end_date: nil
                },
            shopify_info: {
                published_scope: "none",
                inventory_management: nil
                },
            shipping_length: nil,
            shipping_height: nil,
            shipping_width: nil,
            digital: false,
            created_on: "2016-12-21T15:13:30.213",
            updated_on: 1.day.ago
          }
        ]
      end

      def get_inventory_response
        [
          {
            distribution_center_id: 454,
            product_id: 2742840,
            sku: "1111",
            quantity_on_hand: 100.0,
            updated_on: 5.minutes.ago
          },
          {
            distribution_center_id: 454,
            product_id: 2742840,
            sku: "2222",
            quantity_on_hand: 200.0,
            updated_on: 5.minutes.ago
          },
          {
            distribution_center_id: 454,
            product_id: 2742840,
            sku: "3333",
            quantity_on_hand: 300.0,
            updated_on: 5.minutes.ago
          },
          {
            distribution_center_id: 454,
            product_id: 2742840,
            sku: "4444",
            quantity_on_hand: 400.0,
            updated_on: 5.minutes.ago
          }
        ]
      end

      def create_order_response
        [
          {
            order_id: 1000,
            reference_id: "1234",
            orderbot_status_code: "success",
            messages: "The ship confirmation was processed successfully."
          }
        ]
      end

      def create_error_order_response
        {
          errors: {
              distributionCenterId: [ "The DistributionCenterId field is required." ]
          },
          title: "One or more validation errors occurred.",
          status: 400,
          traceId: "0HLRMSI1H2BKA:00000001"
        }
      end

      def get_pricing_response
        [
          {
            effective_date: nil,
            name: "CAN-REWARDS",
            order_guide_id: 1,
            sales_channel_id: 286,
            version_id: 3187,
            products: [
              {
                force_schedule: nil,
                last_updated_on: 5.minutes.ago,
                original_price: 15.0,
                price: 15.0,
                product_id: 3592532,
                sales_end_on: nil,
                sales_start_on: nil,
                sku: "SAMEPRICE1"
              },
              {
                force_schedule: nil,
                last_updated_on: 5.minutes.ago,
                original_price: nil,
                price: 20.0,
                product_id: 3592539,
                sales_end_on: nil,
                sales_start_on: nil,
                sku: "REGULAR1"
              },
              {
                force_schedule: nil,
                last_updated_on: 5.minutes.ago,
                original_price: 45.0,
                price: 30.0,
                product_id: 3592535,
                sales_end_on: nil,
                sales_start_on: nil,
                sku: "SALE1"
              }
            ]
          },
          {
            effective_date: nil,
            name: "UK-Shopify",
            order_guide_id: 2,
            sales_channel_id: 286,
            version_id: 3177,
            products: [
              {
                force_schedule: nil,
                last_updated_on: 5.minutes.ago,
                original_price: nil,
                price: 570.0,
                product_id: 2548678,
                sales_end_on: nil,
                sales_start_on: nil,
                sku: "APP0006"
              },
              {
                force_schedule: nil,
                last_updated_on: 5.minutes.ago,
                original_price: nil,
                price: 570.0,
                product_id: 2855050,
                sales_end_on: nil,
                sales_start_on: nil,
                sku: "APP0010"
              },
              {
                force_schedule: nil,
                last_updated_on: 5.minutes.ago,
                original_price: nil,
                price: 237.5,
                product_id: 3081908,
                sales_end_on: nil,
                sales_start_on: nil,
                sku: "AMP0101"
              }
            ]
          }
        ]
      end

      def get_fulfillments_response
        [
          {
            order_id: "111111111",
            reference_id: "1234",
            purchase_order: "00984",
            ship_date: 5.minutes.ago,
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
          },
          {
            order_id: "99999999",
            reference_id: "4567",
            purchase_order: "00984",
            ship_date: 5.minutes.ago,
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
                    quantity: "1"
                  }
                ]
              }
            ]
          }
        ]
      end
    end
  end
end

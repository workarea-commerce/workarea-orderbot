module Workarea
  module Orderbot
    class BogusGateway
      def initialize(options = {})
      end

      def get_products(attrs = {})
        if attrs[:response_model] == 'CustomField'
          Response.new(response(get_products_custom_field_response))
        else
          Response.new(response(get_products_response))
        end
      end

      def get_inventory(attrs = {})
        Response.new(response(get_inventory_response))
      end

      def create_order(attrs = {})
        if attrs.first[:reference_order_id] == "error"
          Response.new(response(create_error_order_response, 400))
        else
          Response.new(response(create_order_response))
        end
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
    end
  end
end

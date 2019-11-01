module Workarea
  module Orderbot
    class BogusGateway
      def initialize(options = {})
      end

      def get_products(attrs = {})
        Response.new(response(get_products_response))
      end

      def get_inventory(attrs = {})
        Response.new(response(get_inventory_response))
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

      def get_products_response
        [
          {
            product_id: 3647523,
            name: "iPhone X",
            sku: nil,
            upc: "7475876093756837",
            active: true,
            taxable: true,
            base_price: 0,
            orderguide_price: nil,
            units_of_measure: "Each",
            weight: 1,
            shipping_unit_of_measure: "Lbs",
            has_children: true,
            parent_id: 0,
            class_type: "DR-Compoment",
            group_id: 32930,
            group: "Apple ",
            category_id: 7717,
            category: "Phones",
            first_variable_value: nil,
            second_variable_value: nil,
            descriptive_title: nil,
            description: "A refurbed IphoneX",
            other_info: nil,
            creation_date: nil,
            last_updated: 5.minutes.ago,
            updated_by: 205306
          },
          {
            product_id: 3647524,
            name: "iPhone X Rose",
            sku: "applsku1",
            upc: "7475876093756837",
            active: true,
            taxable: true,
            base_price: 799,
            orderguide_price: nil,
            units_of_measure: "Each",
            weight: 1,
            shipping_unit_of_measure: "Lbs",
            has_children: true,
            parent_id: 3647523,
            class_type: "DR-Compoment",
            group_id: 32930,
            group: "Apple ",
            category_id: 7717,
            category: "Phones",
            first_variable_value: "rose",
            second_variable_value: "metal",
            descriptive_title: nil,
            description: nil,
            other_info: nil,
            creation_date: nil,
            last_updated: 5.minutes.ago,
            updated_by: 205306
          },
          {
            product_id: 3647525,
            name: "iPhone X Black",
            sku: "applsku2",
            upc: "74758760945545",
            active: true,
            taxable: true,
            base_price: 899,
            orderguide_price: nil,
            units_of_measure: "Each",
            weight: 1,
            shipping_unit_of_measure: "Lbs",
            has_children: true,
            parent_id: 3647523,
            class_type: "DR-Compoment",
            group_id: 32930,
            group: "Apple ",
            category_id: 7717,
            category: "Phones",
            first_variable_value: "black",
            second_variable_value: "metal",
            descriptive_title: nil,
            description: nil,
            other_info: nil,
            creation_date: nil,
            last_updated: 5.minutes.ago,
            updated_by: 205306
          },
          {
            product_id: 43355343243,
            name: "Google Pixel 4",
            sku: "googlepixel4",
            upc: "74758760945545",
            active: true,
            taxable: true,
            base_price: 899,
            orderguide_price: nil,
            units_of_measure: "Each",
            weight: 1,
            shipping_unit_of_measure: "Lbs",
            has_children: false,
            parent_id: 0,
            class_type: "DR-Compoment",
            group_id: 32930,
            group: "Google ",
            category_id: 7717,
            category: "Phones",
            first_variable_value: "black",
            second_variable_value: "metal",
            descriptive_title: nil,
            description: nil,
            other_info: nil,
            creation_date: nil,
            last_updated: 5.minutes.ago,
            updated_by: 205306
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
    end
  end
end

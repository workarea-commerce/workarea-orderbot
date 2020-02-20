module Workarea
  module Orderbot
    class ParentProduct
      include Filters

      attr_reader :parent_product

      def initialize(parent_product)
        @parent_product = parent_product
      end

      def process
        product.name = product_details[:name]
        product.description = product_details[:description]
        product.active = product_details[:active]

        product.filters = build_product_filters
        product.template = product_template
        set_details
        product.save!
      end

      private

      def product
        @product ||= Workarea::Catalog::Product.find_or_initialize_by(id: id)
      end

      def id
        @id ||= product_details[:product_id]
      end

      def product_details
        parent_product.product_data.deep_symbolize_keys
      end

      def build_product_filters
        existing_filters = product.filters || {}
        new_filters = {
          orderbot_category: product_details[:category],
          orderbot_group: product_details[:group]
        }

        filters = existing_filters.merge(new_filters)
        filters = add_filter_values(filters, first_variable) if first_variable.present?
        filters = add_filter_values(filters, second_variable) if second_variable.present?

        filters
      end

      def set_details
        new_details = {
          upc: product_details[:upc].presence
        }.merge(get_product_details)
        product.update_details(new_details)
      end

      # getting custom attributes for a product requires a seperate API call
      def get_product_details
        attrs = {
          response_model: "CustomField",
          product_ids: product_details[:product_id]
        }

        response = gateway.get_products(attrs)

        return {} unless response.success? && response.body.present?

        response.body.first["custom_fields"].inject({}) do |memo, field|
          memo[field["name"]] = field["value"]
          memo
        end
      end

      def product_template
        template = product_details[:workarea_info][:template]
        return "generic" unless template.present?
        return "generic" unless Workarea.config.product_templates.include?(template.to_sym)
        template
      end

      def gateway
        Workarea::Orderbot.gateway
      end
    end
  end
end

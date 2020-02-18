module Workarea
  module Orderbot
    class ChildProduct
      include Filters

      class ChildProductImportError < StandardError; end
      class NoParentProductImportError < StandardError; end
      attr_reader :child_product

      def initialize(child_product)
        @child_product = child_product
      end

      def process
        raise ChildProductImportError, "Blank Sku for #{product_id}" if sku.blank?
        raise NoParentProductImportError, "No product found for #{product_id}" if product.blank?

        save_variant
        save_price
        save_shipping_sku
        set_product_filters
      end

      private

      def product
        @product ||= Workarea::Catalog::Product.find(product_id) rescue nil
      end

      def product_id
        return product_details[:product_id] if product_details[:parent_id] == 0
        product_details[:parent_id]
      end

      def variant
        @variant ||= product.variants.find_or_initialize_by(sku: sku)
      end

      def save_variant
        variant.name = product_details[:name]
        variant.sku = product_details[:sku]
        variant.active = product_details[:active]
        set_variant_details
        variant.save!
      end

      def set_variant_details
        new_details = {}
        new_details.merge!(first_variable) if first_variable.present?
        new_details.merge!(second_variable) if second_variable.present?
        variant.update_details(new_details)
      end

      def sku
        @sku ||= product_details[:sku]
      end

      def product_details
        @product_details ||= child_product.product_data.deep_symbolize_keys
      end

      def save_price
        pricing_sku = Workarea::Pricing::Sku.find_or_initialize_by(id: sku)
        pricing_sku.prices = [{ regular: product_price.to_m }]
        pricing_sku.save!
      end

      def product_price
        product_details[:orderguide_price] || product_details[:base_price]
      end

      def save_shipping_sku
        shipping_sku = Workarea::Shipping::Sku.find_or_initialize_by(id: sku)
        shipping_sku.weight = shipping_weight
        shipping_sku.dimensions = shipping_sku_dimensions
        shipping_sku.save!
      end

      def shipping_weight
        return unless product_details[:shipping_weight].present?
        return product_details[:shipping_weight] if product_details[:shipping_weight_measurement_unit] == "Oz"
        return (product_details[:shipping_weight] * 16.00).round(2) if product_details[:shipping_weight_measurement_unit] == "Lbs"
        return (product_details[:shipping_weight] * 1000.00).round(2) if product_details[:shipping_weight_measurement_unit] == "Kgs"
      end

      def set_product_filters
        existing_filters = product.filters || {}

        new_filters = {
          orderbot_category: product_details[:category],
          orderbot_group: product_details[:group]
        }.compact

        filters = existing_filters.merge(new_filters)
        filters = add_filter_values(filters, first_variable) if first_variable.present?
        filters = add_filter_values(filters, second_variable) if second_variable.present?

        product.filters = filters
        product.save!
      end

      def shipping_sku_dimensions
        return unless product_details[:shipping_width].present? && product_details[:shipping_height].present? && product_details[:shipping_length].present?
        [product_details[:shipping_height], product_details[:shipping_width], product_details[:shipping_length]]
      end
    end
  end
end

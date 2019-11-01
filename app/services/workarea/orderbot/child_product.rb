module Workarea
  module Orderbot
    class ChildProduct
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
        set_variant_details
        variant.save!
      end

      def set_variant_details
        #TODO - work with OB to get the key names to use here.
        new_details = {
          detail_1: product_details[:first_variable_value],
          detail_2: product_details[:second_variable_value]
        }

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
        shipping_sku.save!
      end

      def shipping_weight
        return unless product_details[:weight].present?
        return product_details[:weight] if product_details[:shipping_unit_of_measure] == "Oz"
        return (product_details[:weight] * 16.00).round(2) if product_details[:shipping_unit_of_measure] == "Lbs"
        return (product_details[:weight] * 1000.00).round(2) if product_details[:shipping_unit_of_measure] == "Kgs"
      end
    end
  end
end

module Workarea
  module Orderbot
    class ParentProduct
      attr_reader :parent_product

      def initialize(parent_product)
        @parent_product = parent_product
      end

      def process
        product.name = product_details[:name]
        product.description = product_details[:description]

        product.filters = build_product_filters
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
          category_id: product_details[:category_id],
          category: product_details[:category]
        }

        existing_filters.merge(new_filters)
      end

      def set_details
        new_details = {
          upc: product_details[:upc].presence
        }
        product.update_details(new_details)
      end
    end
  end
end

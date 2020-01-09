module Workarea
  module Orderbot
    class ProductImporter
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(options = {})
        return unless Orderbot.api_configured?

        Orderbot::ImportLog.log('product')  do |last_imported_at|
          last_import = options[:from_updated_on] || last_imported_at

          attrs = {
            response_model: "integration",
            sort_by: "LastUpdatedOn"
          }.merge!(product_filters)

          response = gateway.get_products(attrs)
          write_products(response.body, last_import)

          if response.total_pages.to_i > 1
            count = 2

            while count <= response.total_pages.to_i
              page_attrs = attrs.merge(page: count)
              response = gateway.get_products(page_attrs)
              write_products(response.body, last_import)
              count = count + 1
            end
          end
          # import the ob parent products - Top level workarea prodcuts
          Orderbot::Product::ImportParentProducts.new.perform

          # import the children products - workarea variants, pricing and shipping skus
          Orderbot::Product::ImportChildProducts.new.perform
        end
      end

      private

      def write_products(products, last_update_threshold)
        products.each do | product_data|
          next if Time.parse(product_data["updated_on"]).iso8601 < last_update_threshold.in_time_zone(Workarea.config.orderbot_api_timezone).iso8601

          parent_product = product_data["parent_id"] == 0
          parent_product_id = product_data["parent_id"]
          has_children = product_data["has_children"]

          Orderbot::ProductImportData.create!(
            product_data: product_data,
            parent_product: parent_product,
            parent_product_id: parent_product_id,
            has_children: has_children
          )
        end
      end

      def gateway
        Workarea::Orderbot.gateway
      end

      def product_filters
        config_filters = Workarea.config.product_import_filters || {}
        config_filters.merge!(order_guide: Workarea.config.default_order_guide_id) if Workarea.config.default_order_guide_id.present?

        config_filters
      end
    end
  end
end

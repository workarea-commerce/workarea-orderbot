module Workarea
  module Orderbot
    class InventoryImporter
      include Sidekiq::Worker
      sidekiq_options retry: 5

      def perform(options = {})
        return unless Orderbot.api_configured?

        Orderbot::ImportLog.log('inventory')  do |last_imported_at|
          from_updated_on = options[:from_updated_on] || last_imported_at

          inventory_filters = {
            from_updated_on:  from_updated_on.iso8601,
            distribution_center_id: Workarea.config.inventory_distribution_center_id
          }

          inventory_response = gateway.get_inventory(inventory_filters)
          raise 'get inventory error' unless  inventory_response.success?

          inventory_records = inventory_response.body

          import_inventory_records(inventory_records)

          if inventory_response.total_pages.to_i > 1
            count = 2

            while count <= inventory_response.total_pages.to_i
              page_filters = inventory_filters.merge(page: count)
              response = gateway.get_products(page_filters)

              import_inventory_records(response.body)

              count = count + 1
            end
          end

          inventory_records.each do |inventory|
            Orderbot::Inventory::ImportInventory.new.perform(inventory)
          end
        end
      end

      private

      def gateway
        Workarea::Orderbot.gateway
      end

      def import_inventory_records(inventory_records)
        inventory_records.each do |inventory|
          Orderbot::Inventory::ImportInventory.new.perform(inventory)
        end
      end
    end
  end
end

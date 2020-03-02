module Workarea
  module Orderbot
    module Inventory
      class ImportInventory
        include Sidekiq::Worker

        def perform(attrs = {})
          inventory = attrs.deep_symbolize_keys

          return unless inventory[:sku].present?

          sku = Workarea::Inventory::Sku.find_or_initialize_by(id: inventory[:sku])

          sku.available = inventory[:quantity_on_hand] || 0
          sku.policy = get_policy(inventory[:sku])

          sku.save!
        end

        private

        def get_policy(sku)
          return "allow_backorder" if is_backorderable?(sku)
          Workarea.config.default_inventory_import_policy || "standard"
        end

        def is_backorderable?(sku)
          gateway = Workarea::Orderbot.gateway

          attrs = {
            response_model: "CustomField",
            sku: sku
          }

          response = gateway.get_products(attrs)

          return unless response.success? && response.body.present?

          fields = response.body.first["custom_fields"]

          backorder_field = fields.detect{ |f| f["name"] == "backorderable"}

          return unless backorder_field.present?

          backorder_field["value"]
        end
      end
    end
  end
end

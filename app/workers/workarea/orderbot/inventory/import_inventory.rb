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
          sku.policy = Workarea.config.inventory_import_default_policy || "standard"

          sku.save!
        end
      end
    end
  end
end

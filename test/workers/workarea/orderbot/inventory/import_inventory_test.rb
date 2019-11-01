require 'test_helper'

module Workarea
  module Orderbot
    class Inventory::ImportInventoryTest < TestCase
      def test_import_inventory
        inventory_data = {
          distribution_center_id: 454,
          product_id: 2742840,
          sku: "4444",
          quantity_on_hand: 400.0,
          updated_on: 5.minutes.ago
        }

        Workarea::Orderbot::Inventory::ImportInventory.new.perform(inventory_data)
        sku = Workarea::Inventory::Sku.first

        assert_equal(400, sku.available)
        assert_equal("standard", sku.policy)

        inventory_data[:quantity_on_hand] = 500

        Workarea::Orderbot::Inventory::ImportInventory.new.perform(inventory_data)

        sku.reload

        # assert new sku was not created when upating
        assert_equal(1, Workarea::Inventory::Sku.count)
        assert_equal(500, sku.available)
      end
    end
  end
end

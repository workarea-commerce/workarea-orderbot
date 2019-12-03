module Workarea
  module Orderbot
    class Order
      class Item
        attr_reader :item, :options

        def initialize(item, options = {})
          @item = item
          @options = options
        end

        def to_h
          {
            order_line_id: item.id.to_s,
            sku: item.sku,
            quantity: item.quantity,
            unit_price: item.original_unit_price.to_f,
            discount: item_discount,
            total: item.total_value.to_f,
            tax_total: item_tax_total,
            order_product_taxes: taxes
          }
        end

        private

        def taxes
          return [] unless item_taxes.present?
          item_taxes.map do |tax|
            {
              "tax_name": "TAX",
              "amount": tax.amount.to_f,
              "tax_rate": tax_rate(tax.amount)
            }
          end
        end

        def item_discount
          item
            .price_adjustments
            .select { |pa| pa.discount? }
            .sum(&:amount)
            .abs
            .to_f
        end

        def item_taxes
          return unless shipping.present?
          shipping.price_adjustments.adjusting('tax').select { |pa| pa["data"]["order_item_id"].to_s == item.id.to_s }
        end

        def item_tax_total
          return 0.to_f unless item_taxes.present?
          @item_tax_total ||= item_taxes.sum(&:amount).to_f
        end

        def tax_rate(amount)
          return 0 if item_tax_total == 0
            # back into tax rate,  use to_m.to_f to smooth out rounding.
            (amount.to_f / item.total_price.to_f).to_m.to_f
        end

        def shipping
          @shipping ||= options[:shipping]
        end
      end
    end
  end
end

module Workarea
  module Orderbot
    module Pricing
      class ImportPricing
        include Sidekiq::Worker

        def perform
          Workarea::Orderbot::PricingImportData.each do |sku_price|
            pricing_data = sku_price.pricing_data.deep_symbolize_keys

            next unless pricing_data[:sku].present?
            sku = Workarea::Pricing::Sku.find_or_initialize_by(id: pricing_data[:sku])

            original_price = pricing_data[:original_price]
            price =  pricing_data[:price]

            regular = regular_price(price, original_price)
            sale = sale_price(price, original_price)

            sku.on_sale = sale.present?
            sku.prices = [{ regular: regular, sale: sale, on_sale: sale.present? }]
            sku.save!

            sku_price.delete
          end
        end

        private

        def regular_price(price, original_price)
          return original_price if original_price.present? && original_price > price
          price
        end

        def sale_price(price, original_price)
          return nil if original_price.blank? || original_price == price
          price
        end
      end
    end
  end
end

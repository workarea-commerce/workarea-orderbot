module Workarea
  module Orderbot
    module Product
      class ImportChildProducts
        include Sidekiq::Worker

        def perform
          Orderbot::ProductImportData.child_products.each do |child_product|
            result = begin
              Workarea::Orderbot::ChildProduct.new(child_product).process
            rescue StandardError => e
              child_product.update_attributes!(error_message: e.message)
              false
            end

            if result
              child_product.delete
            end
          end
        end
      end
    end
  end
end

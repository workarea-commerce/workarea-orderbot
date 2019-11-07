module Workarea
  module Orderbot
    module Product
      class ImportParentProducts
        include Sidekiq::Worker

        def perform
          Orderbot::ProductImportData.parent_products.each do |parent_product|
            result = begin
              Orderbot::ParentProduct.new(parent_product).process

              # if a parent product has no children then import the variants
              # pricing and shipping skus
              if !parent_product.has_children
                Orderbot::ChildProduct.new(parent_product).process
              end

              true
            rescue StandardError => e
              parent_product.update_attributes!(error_message: e.message)
              false
            end

            if result
              parent_product.delete
            end
          end
        end
      end
    end
  end
end

module Workarea
  module Orderbot
    class ProductImportData
      include ApplicationDocument

      field :product_id, type: String
      field :product_data, type: Hash
      field :parent_product, type: Boolean, default: false
      field :has_children, type: Boolean, default: false
      field :parent_product_id, type: String
      field :error_message, type: String

      index({ created_at: 1 }, { expire_after_seconds: 6.months.seconds.to_i })
      index({ parent_product_id: 1 })
      index({ parent_product: 1 })
      index({ product_id: 1 })

      index(
        {
          parent_product: 1,
          has_children: 1
        },
        {
          name: 'child_product_import_index'
        }
      )

      scope :parent_products, -> { where(parent_product: true) }
      scope :child_products, -> { any_of({ parent_product: false }, { parent_product: true, has_children: false }) }
    end
  end
end

module Workarea
  module Orderbot
    class PricingImportData
      include ApplicationDocument

      field :pricing_data, type: Hash
      field :order_guide_id, type: String

      index({ created_at: 1 }, { expire_after_seconds: 6.months.seconds.to_i })
      index({ order_guide_id: 1 })
    end
  end
end

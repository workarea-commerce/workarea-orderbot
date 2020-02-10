module Workarea
  module Orderbot
    class Order
      module Tender
        class StoreCredit
          attr_reader :tender, :options

          def initialize(tender, options = {})
            @tender = tender
            @option = options
          end

          def to_h
            {
              payment_reference_id: tender.id.to_s,
              payment_type: "cheque",
              payment_method_type:  "paid_from_web",
              amount_paid: tender.amount.to_f,
              payment_date: transaction.created_at.iso8601
            }
          end

          private

          def transaction
             tender.transactions.successful.sort_by(&:created_at).last
          end
        end
      end
    end
  end
end

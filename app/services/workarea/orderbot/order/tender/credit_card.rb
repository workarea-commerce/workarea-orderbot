module Workarea
  module Orderbot
    class Order
      module Tender
        class CreditCard
          attr_reader :tender, :options

          def initialize(tender, options = {})
            @tender = tender
            @option = options
          end

          def to_h
            {
              payment_reference_id: tender.id.to_s,
              payment_type: "credit_card",
              payment_method_type:  tender.issuer.optionize,
              amount_paid: tender.amount.to_f,
              payment_date: transaction.created_at.iso8601,
              auth_code: transaction.response.authorization,
              credit_card: {
                transaction_id: transaction_id,
                authorization_code: transaction.response.authorization,
                last_four_digits: tender.display_number.last(4)
              }
            }
          end

          private

          def transaction
             tender.transactions.successful.sort_by(&:created_at).last
          end

          def transaction_id
            gateway_class = Workarea.config.gateways.credit_card.class.to_s
            Workarea.config.orderbot.transaction_id[gateway_class].call(transaction) rescue nil
          end
        end
      end
    end
  end
end

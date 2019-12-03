module Workarea
  module Orderbot
    class Order
      attr_reader :order

      def initialize(order_id)
        wa_order = Workarea::Order.find(order_id)
        @order = Workarea::Storefront::OrderViewModel.new(wa_order)
      end

      def to_a
        [
          {
            reference_order_id: order.id,
            order_date: order.placed_at.iso8601,
            order_status: "unshipped",
            orderbot_account_id: orderbot_customer_id, # account and customer ids are the same
            orderbot_customer_id: orderbot_customer_id,
            reference_account_id: reference_customer_id,
            reference_customer_id: reference_customer_id,
            distribution_center_id: Workarea.config.inventory_distribution_center_id,
            order_guide_id: Workarea.config.default_order_guide_id,
            email_confirmation_address: order.email,
            subtotal: subtotal,
            order_discount: discount_amount,
            order_total: order.total_price.to_f,
            shipping_info: shipping_info,
            ship_to: shipping_address,
            billing_to: billing_address,
            order_items: items,
            payments: payments
          }
        ]
      end

      private

      def payments
        payment.tenders.map do |tender|
          case tender.slug
          when :credit_card
            Order::Tender::CreditCard.new(tender).to_h
          else
            Order::Tender::General.new(tender).to_h
          end
        end
      end


      def shipping_info
        return unless shipping.present?
        {
          ship_date: ship_date,
          shipping_code: shipping.shipping_service.service_code,
          shipping_total: shipping.shipping_total.to_f,
        }
      end

      def items
        order.items.map do |item|
          Orderbot::Order::Item.new(item, { shipping: shipping }).to_h
        end
      end

      def address(obj)
        return unless  obj.present?
        {
          first_name: obj.first_name,
          last_name: obj.last_name,
          company: obj.company,
          address: obj.street,
          address2: obj.street_2,
          city: obj.city,
          state_name: obj.region,
          postal_code: obj.postal_code,
          country: obj.country.alpha2,
          phone: obj.phone_number
        }
      end

      def shipping_address
        address(order.shipping_address)
      end

      def billing_address
        address(order.billing_address).merge(email: order.email)
      end

      def shipping
        @shipping ||= Workarea::Shipping.find_by_order(order.id)
      end

      def payment
        @payment ||= Workarea::Payment.find(order.id)
      end

      def ship_date
        Workarea.config.shipping_date_lead_time.from_now
      end

      def discount_amount
        order
          .price_adjustments
          .select { |pa| pa.discount? }
          .sum(&:amount)
          .abs
          .to_f
      end

      def subtotal
        (order.total_value.to_f - discount_amount)
      end

      def user
        return unless order.user_id
        @user ||= Workarea::User.find(order.user_id)
      end

      def orderbot_customer_id
        return unless user.present?
        user.orderbot_customer_id
      end

      # reference customer ID is not required if the
      # customer exists in orderbot already
      def reference_customer_id
        return if user.present? && user.orderbot_customer_id.present?
        order.email
      end
    end
  end
end

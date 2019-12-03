require 'test_helper'

module Workarea
  module Orderbot
    class OrderTest < Workarea::TestCase
      def test_to_a
        Workarea.config.inventory_distribution_center_id = 100
        Workarea.config.default_order_guide_id = 200

        create_order_total_discount(order_total: 1.to_m)

        order = Workarea::Storefront::OrderViewModel.new(create_placed_order)
        orderbot_order = Orderbot::Order.new(order.id).to_a.first

        assert_equal(order.id, orderbot_order[:reference_order_id])
        assert_equal("unshipped", orderbot_order[:order_status])
        assert_equal(order.email, orderbot_order[:reference_account_id])
        assert_equal(order.email, orderbot_order[:reference_customer_id])
        assert_equal(100, orderbot_order[:distribution_center_id])
        assert_equal(200, orderbot_order[:order_guide_id])
        assert_equal(order.email, orderbot_order[:email_confirmation_address])
        assert_equal(8.0, orderbot_order[:subtotal])
        assert_equal(1.0, orderbot_order[:order_discount])
        assert_equal(order.total_price.to_f, orderbot_order[:order_total])

        shipping_info = orderbot_order[:shipping_info]
        assert_equal(1.0, shipping_info[:shipping_total])

        ship_to = orderbot_order[:ship_to]
        assert_equal(order.shipping_address.first_name, ship_to[:first_name])
        assert_equal(order.shipping_address.last_name, ship_to[:last_name])
        assert_equal(order.shipping_address.street, ship_to[:address])
        assert_equal(order.shipping_address.street_2, ship_to[:address2])
        assert_equal(order.shipping_address.city, ship_to[:city])
        assert_equal(order.shipping_address.region, ship_to[:state_name])
        assert_equal(order.shipping_address.postal_code, ship_to[:postal_code])
        assert_equal(order.shipping_address.country.alpha2, ship_to[:country])

        billing_to = orderbot_order[:billing_to]
        assert_equal(order.billing_address.first_name, billing_to[:first_name])
        assert_equal(order.billing_address.last_name, billing_to[:last_name])
        assert_equal(order.billing_address.street, billing_to[:address])
        assert_equal(order.billing_address.street_2, billing_to[:address2])
        assert_equal(order.billing_address.city, billing_to[:city])
        assert_equal(order.billing_address.region, billing_to[:state_name])
        assert_equal(order.billing_address.postal_code, billing_to[:postal_code])
        assert_equal(order.billing_address.country.alpha2, billing_to[:country])
        assert_equal(order.email, billing_to[:email])

        ob_item = orderbot_order[:order_items].first
        wa_item = order.items.first
        assert_equal(wa_item.id.to_s, ob_item[:order_line_id])
        assert_equal(wa_item.sku, ob_item[:sku])
        assert_equal(wa_item.quantity, ob_item[:quantity])
        assert_equal(5.0, ob_item[:unit_price])
        assert_equal(1.0, ob_item[:discount])
        assert_equal(9.0, ob_item[:total])

        wa_tender = Workarea::Payment.find(order.id).tenders.first
        ob_tender = orderbot_order[:payments].first

        assert_equal(wa_tender.id.to_s, ob_tender[:payment_reference_id])
        assert_equal("credit_card", ob_tender[:payment_type])
        assert_equal("test_card", ob_tender[:payment_method_type])
        assert_equal(10.0, ob_tender[:amount_paid])
      end

      def test_multiple_tenders
        order = Workarea::Storefront::OrderViewModel.new(create_placed_dual_tender_order)
        orderbot_order = Orderbot::Order.new(order.id).to_a.first
        payments = orderbot_order[:payments]

        assert_equal(2, payments.size)

        credit_card = payments.detect { |p| p[:payment_type] == "credit_card" }
        assert_equal("visa", credit_card[:payment_method_type])

        store_credit = payments.detect { |p| p[:payment_type] == "unknown" }
        assert_equal("paid_from_web", store_credit[:payment_method_type])
      end

      private

      def create_placed_dual_tender_order(overrides = {}, options = {})
        attributes = {
          id: '1234',
          email: 'tester@workarea.com',
          placed_at: Time.current,
          ip_address: '127.0.0.1',
          user_agent: 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0 Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0.'
        }.merge(overrides)

        shipping_service = create_shipping_service
        sku = 'SKU'
        create_product(variants: [{ sku: sku, regular: 5.to_m }])
        details = OrderItemDetails.find(sku)
        order = Workarea::Order.new(attributes)
        item = { sku: sku, quantity: 2 }.merge(details.to_h)

        order.add_item(item)

        checkout = Checkout.new(order)
        checkout.update(
          shipping_address: {
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '22 S. 3rd St.',
            street_2: 'Second Floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          },
          billing_address: {
            first_name: 'Ben',
            last_name: 'Crouse',
            street: '12 N. 3rd St.',
            street_2: 'thrid floor',
            city: 'Philadelphia',
            region: 'PA',
            postal_code: '19106',
            country: 'US'
          },
          shipping_service: shipping_service.name,
        )

        checkout.payment_profile.store_credit = 1.0
        checkout.payment.build_store_credit

        checkout.update(
          payment: 'new_card',
          credit_card: {
            number: '4111111111111111',
            month: '1',
            year: Time.current.year + 1,
            cvv: '999'
            }
        )

        checkout.place_order

        forced_attrs = overrides.slice(:placed_at, :update_at, :total_price)
        order.update_attributes!(forced_attrs)
        order
      end
    end
  end
end

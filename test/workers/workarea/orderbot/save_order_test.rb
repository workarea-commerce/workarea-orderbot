require 'test_helper'

module Workarea
  class Orderbot::SaveOrderTest < TestCase
    def test_export_order
      Workarea.config.orderbot_api_email_address = "test@workarea.com"
      Workarea.config.orderbot_api_password = "foobar"

      order = create_placed_order

      Workarea::Orderbot::SaveOrder.new.perform(order.id)

      order.reload

      assert(order.orderbot_order_id.present?)
      assert(order.orderbot_exported?)
    end

    def test_export_order_error
      Workarea.config.orderbot_api_email_address = "test@workarea.com"
      Workarea.config.orderbot_api_password = "foobar"

      order = create_placed_order(id: "error")

      assert_raise Workarea::Orderbot::SaveOrder::OrderbotSaveOrderError do
        Workarea::Orderbot::SaveOrder.new.perform(order.id)
      end
    end

     def test_export_fails_to_create
      Workarea.config.orderbot_api_email_address = "test@workarea.com"
      Workarea.config.orderbot_api_password = "foobar"

      order = create_placed_order(id: "failure")

      assert_raise Workarea::Orderbot::SaveOrder::OrderbotSaveOrderError do
        Workarea::Orderbot::SaveOrder.new.perform(order.id)
      end
    end
  end
end

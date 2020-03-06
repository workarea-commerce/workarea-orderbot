module Workarea
  module Orderbot
    class SaveOrder
      class OrderbotSaveOrderError < StandardError; end
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: { Workarea::Order => [:place] },
        unique: :until_executing
      )

      def perform(id)
        return unless Orderbot.api_configured?

        order = Workarea::Order.find(id)
        orderbot_order = Workarea::Orderbot::Order.new(order.id)
        response = Workarea::Orderbot.gateway.create_order(orderbot_order.to_a)

        raise OrderbotSaveOrderError, response.error_details unless response.success?
        raise OrderbotSaveOrderError, messages(response.body) unless created?(response.body) # checks for a 200 response that fails to create the order

        orderbot_order_id = response.body.first["order_id"]
        order.set_orderbot_exported_data!(orderbot_order_id)
      end

      private

      def created?(body)
        body.first["orderbot_status_code"] == "success"
      end

      def messages(body)
        body.first["messages"].join(",")
      end
    end
  end
end

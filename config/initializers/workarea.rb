Workarea.configure do |config|
  config.orderbot = ActiveSupport::Configurable::Configuration.new
  config.orderbot.api_timeout = 10
  config.orderbot.open_timeout = 10

  # Time frame to look for updated inventory in the orderbot api.
  config.orderbot.inventory_import_time_frame = 1.hour

  # Time frame to look for updated products in orderbot.
  # Products in orderbot older than this time frame will not
  # be imported or udpated via the import process.
  config.orderbot.product_import_time_frame = 1.day
end

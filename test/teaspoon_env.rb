require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::Orderbot::Engine.root
  Workarea::Teaspoon.apply(config)
end

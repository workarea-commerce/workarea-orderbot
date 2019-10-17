require 'workarea/orderbot'

module Workarea
  module Orderbot
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Orderbot
    end
  end
end

$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/orderbot/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "workarea-orderbot"
  spec.version     = Workarea::Orderbot::VERSION
  spec.authors     = ["Jeff Yucis"]
  spec.email       = ["jyucis@workarea.com"]
  spec.homepage    = "https://github.com/workarea-commerce/workarea-orderbot"
  spec.summary     = "Workarea Integration with Orderbot OMS."
  spec.description = "Ordebot OMS integration for catalog and order data."
  spec.license     = "Business Software License"

  spec.files = `git ls-files`.split("\n")

  spec.add_dependency 'workarea', '>= 3.4.x'
end

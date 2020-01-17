Sidekiq::Cron::Job.create(
  name: 'Workarea::Orderbot::ProductImporter',
  klass: 'Workarea::Orderbot::ProductImporter',
  cron: '0 2 * * *',
  queue: 'low'
)


Sidekiq::Cron::Job.create(
  name: 'Workarea::Orderbot::InventoryImporter',
  klass: 'Workarea::Orderbot::InventoryImporter',
  cron: '0 * * * *',
  queue: 'low'
)


Sidekiq::Cron::Job.create(
  name: 'Workarea::Orderbot::PricingImporter',
  klass: 'Workarea::Orderbot::PricingImporter',
  cron: '30 * * * *',
  queue: 'low'
)

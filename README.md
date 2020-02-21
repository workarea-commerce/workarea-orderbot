Workarea Orderbot
================================================================================

Orderbot integration for the Workarea platform.

This integration pulls catalog information from the Orderbot REST API and pushes order and customer data back.

Overview
--------------------------------------------------------------------------------

The following catalog data is pulled from Orderbot:

* Products
* Pricing
* Inventory
* Fulfillments

The following is pushed to Orderbot:

* Orders
* Customer data (contained in order)

The synchronization of data relies on cron jobs defined in this plugin.

The defaults are:

* **Products**: Daily at 2:00am
* **Inventory**: Every hour on the hour
* **Pricing**: Every hour at the 30 minute mark
* **Fulfillments**: Every 20 minutes

Host apps can change these defaults by redefining them in their own initializer.

Each of these scheduled jobs are designed to only pull records from Orderbot that have changed since the last run of the job. You can pass an argument named "from_updated_on" with a datetime to the job via the the command line if you need to run an import on a longer time frame.

For example:
```ruby
 Workarea::Orderbot::ProductImporter.new.perform(from_updated_on: 1.month.ago) # gets all products updated within the last month
```

Useful information is stored in ```Workarea::Orderbot::ImportLog``` with data about which import ran, when it started and finished.

Orders placed in Workarea are queued in Sidekiq and are not sent in a batch.

Configuration
--------------------------------------------------------------------------------

This integration's configuration can be controlled via the admin configuration panel.

Notable configurations:

* **Orderbot API Email Address**: Email address used to login to your Orderbot admin. This user must have API access.
* **Orderbot API Password**: Password used to login to the Orderbot admin.
* **Order Guide ID**: The order guide ID used to get products and prices. Recommended to not leave this field blank.
* **Inventory Distribution Center ID**: The distribution center ID to pull inventory from. Leaving this field blank will pull inventory for all DCs and can lead to unexpected results.

See the "Orderbot" section under configuration for more options and details.

Getting Started
--------------------------------------------------------------------------------

This gem contains a Rails engine that must be mounted onto a host Rails application.

Add the gem to your application's Gemfile:

    # ...
    gem 'workarea-orderbot'
    # ...

Update your application's bundle.

    cd path/to/application
    bundle


Workarea Platform Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea platform documentation.

License
--------------------------------------------------------------------------------

Workarea Orderbot is released under the [Business Software License](LICENSE)

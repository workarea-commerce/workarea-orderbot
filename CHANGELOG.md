Workarea Orderbot 1.0.2 (2020-07-23)
--------------------------------------------------------------------------------

*   Fix typo in index name


    Ben Crouse



Workarea Orderbot 1.0.1 (2020-04-06)
--------------------------------------------------------------------------------

*   Add compatibility with Workarea v3.4

    * Checking if Workarea respond_to define_fields
    * Define configuration defaults
    * Allow v3.5 since this would be compatible

    Co-authored-by: Ben Crouse <bencrouse@gmail.com>
    Rocela Durazo



Workarea Orderbot 1.0.0 (2020-03-13)
--------------------------------------------------------------------------------

*   Use correct date filter when polling for orderbot fulfillment records

    ORDERBOT-15
    Jeff Yucis

*   Ensure product data is not duplicated in import products.

    Commit also increases gateway timeout to avoid duplicate orders

    ORDERBOT-14
    Jeff Yucis

*   Handle successfull responses that fail to save in orderbot

    Commit handles case where the API response is a 200 but the order
    fails to create the record in orderbot.

    ORDERBOT-13
    Jeff Yucis

*   reset timeouts to defaults 10 seconds

    Jeff Yucis

*   Add taxes at the order level

    ORDERBOT-12
    Jeff Yucis

*   Style fixes

    Jeff Yucis

*   Set backorder inventory policy based on backorderable custom field

    ORDERBOT-9
    Jeff Yucis

*   Only pull active pricing when updated Workarea pricing

    ORDERBOT-10
    Jeff Yucis

*   Add gift card and store credit payment types

    ORDERBOT-6
    Jeff Yucis

*   Pull catalog data from orderbot APIs

    ORDERBOT-1
    Jeff Yucis




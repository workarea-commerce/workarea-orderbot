Workarea::Configuration.define_fields do
  fieldset 'Orderbot', namespaced: false do
    field 'Orderbot API Email Address',
      type: :string,
      description: 'Email Address of Orderbot admin, used to authenticate to the API. This email address is the same that is used to login to the Orderbot admin.',
      allow_blank: false,
      encrypted: false

    field 'Orderbot API Password',
      type: :string,
      description: 'Password of Orderbot admin, used to authenticate to the API. This password is the same that is used to login to the Orderbot admin.',
      allow_blank: false,
      encrypted: true

    field 'Default Order Guide ID',
      type: :integer,
      description: 'What order guide ID is used to filter products on import. This value will also be sent when an order is exported to Orderbot.',
      allow_blank: true

    field 'Inventory Distribution Center ID',
      type: :integer,
      description: 'What inventory distribution center to import inventory from. Leaving this field blank will import inventory from all centers and is not recommended. This field will also be used as the default distribution center on order export.',
      allow_blank: true

    field 'Default Inventory Import Policy',
      type: :symbol,
      default: "standard",
      description: 'The default policy to use when importing inventory from the Orderbot API.',
      allow_blank: false,
      values: -> do
        Workarea.config.inventory_policies.map do |class_name|
          [class_name.demodulize.titleize, class_name.demodulize.underscore]
        end
      end

    field 'Product Import filters',
      type: :hash,
      values_type: :string,
      default: {},
      description: 'Additional filters to pass to the API when importing products. For example "group: robots"',
      allow_blank: true

    field 'Orderbot API Timezone',
      type: :string,
      default: "Eastern Time (US & Canada)",
      description: 'Set this value to match the timezone Orderbot sends any date-time information via the API. Consult with Orderbot before changing this value.',
      allow_blank: false,
      values: -> { ActiveSupport::TimeZone.all.map(&:name) }

    field 'Shipping Date Lead Time',
      type: :duration,
      default: 3.days,
      description: 'Lead time used to generate the "ship date" field when an order is placed. This time will added to the current date and sent to Orderbot when an order is placed.'
  end
end

module Workarea
  module Orderbot
    module Filters
      def add_filter_values(filters, new_filter)
        key = new_filter.keys.first
        val = new_filter[key]

        if filters.key?(key)
          filters[key] << val
          filters[key] = filters[key].uniq
         else

          filters[key] = [val]
        end
        filters
      end

      def first_variable
        return {} unless product_details[:first_variable].present? && product_details[:first_variable][:group].present?
        {
         product_details[:first_variable][:group] => product_details[:first_variable][:value]
        }.compact
      end

      def second_variable
        return {} unless product_details[:second_variable].present? && product_details[:second_variable][:group].present?
        {
         product_details[:second_variable][:group] => product_details[:second_variable][:value]
        }.compact
      end
    end
  end
end

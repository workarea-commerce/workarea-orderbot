module Workarea
  module Orderbot
    class ImportLog
      include ApplicationDocument

      field :importer, type: String
      field :started_at, type: Time
      field :finished_at, type: Time

      def self.log(type)
        instance = find_or_create_by(importer: type)
        last_imported_at = instance.started_at || 1.day.ago
        instance.update!(started_at: Time.current, finished_at: nil)
        yield(last_imported_at)
        instance.update!(finished_at: Time.current)
      end
    end
  end
end

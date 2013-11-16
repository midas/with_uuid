module HasUuid
  module Extensions

    autoload :Migrations, 'has_uuid/extensions/migrations'

    def self.apply!
      if defined? ActiveRecord::ConnectionAdapters::Table
        ActiveRecord::ConnectionAdapters::Table.send :include, HasUuid::Extensions::Migrations
      end
      if defined? ActiveRecord::ConnectionAdapters::TableDefinition
        ActiveRecord::ConnectionAdapters::TableDefinition.send :include, HasUuid::Extensions::Migrations
      end
    end

  end
end

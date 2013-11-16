module WithUuid
  module Extensions

    autoload :Migrations, 'with_uuid/extensions/migrations'

    def self.apply!
      if defined? ActiveRecord::ConnectionAdapters::Table
        ActiveRecord::ConnectionAdapters::Table.send :include, WithUuid::Extensions::Migrations
      end
      if defined? ActiveRecord::ConnectionAdapters::TableDefinition
        ActiveRecord::ConnectionAdapters::TableDefinition.send :include, WithUuid::Extensions::Migrations
      end
    end

  end
end

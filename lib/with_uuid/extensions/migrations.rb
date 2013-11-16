require 'active_record'

module WithUuid
  module Extensions

    module Migrations

      def uuid(*column_names)
        options = column_names.extract_options!
        column_names.each do |name|
          type = case(@base.adapter_name.downcase)
                 when 'sqlserver'
                   'uniqueidentifier'
                 when 'postgresql'
                   'uuid'
                 else
                   'varchar(36)'
                 end
          column(name, "#{type}#{' PRIMARY KEY' if options.delete(:primary_key)}", options)
        end
      end

      def uuid_fk(*column_names)
        uuid( *column_names )
      end

    end

  end
end

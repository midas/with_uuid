require 'active_record'

module WithUuid
  module Extensions

    module Migrations

      def uuid(*column_names)
        options = column_names.extract_options!
        column_names.each do |name|
          type = 'varchar(36)'
          # Handle Table (and TableDefinition in Rails 3)
          if @base
            case(@base.adapter_name.downcase)
            when 'sqlserver'
              type = 'uniqueidentifier'
            when 'postgresql'
              type = 'uuid'
            end
          # Handle TableDefinition in Rails 4
          elsif @native
            if @native[:uuid] #postgres in 4.0 already defines uuid
              type = @native[:uuid].is_a?(Hash) ? @native[:uuid][:name] : 'uuid'
            elsif @native[:ss_timestamp]  #sqlserver
              type = 'uniqueidentifier'
            end
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

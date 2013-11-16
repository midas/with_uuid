module ActiveRecord
  # = Active Record Schema Dumper
  #
  # This class is used to dump the database schema for some connection to some
  # output format (i.e., ActiveRecord::Schema).
  class SchemaDumper #:nodoc:
    private

      def uuid_sql_types
        [
          'varchar(36)',
          'uniqueidentifier'
        ]
      end

      def table(table, stream)
        columns = @connection.columns(table)
        begin
          tbl = StringIO.new

          # first dump primary key column
          pk = nil
          if @connection.respond_to?(:pk_and_sequence_for)
            pk, _ = @connection.pk_and_sequence_for(table)
          end
          if @connection.respond_to?(:primary_key) && pk.nil?
            pk = @connection.primary_key(table)
          end

          tbl.print "  create_table #{remove_prefix_and_suffix(table).inspect}"
          if pk_col = columns.detect { |c| c.name == pk }
            if pk != 'id'
              tbl.print %Q(, :primary_key => "#{pk}")
            end
            if uuid_sql_types.include?( pk_col.sql_type  )
              tbl.print ", :id => false"
            end
          else
            tbl.print ", :id => false"
          end
          tbl.print ", :force => true"
          tbl.puts " do |t|"

          # then dump all non-primary key columns
          column_specs = columns.map do |column|
            raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" if @types[column.type].nil?
            next if column.name == pk
            spec = {}
            spec[:name]      = column.name.inspect

            #debugger if column.name.include?( 'id' )
            # AR has an optimization which handles zero-scale decimals as integers. This
            # code ensures that the dumper still dumps the column as a decimal.
            spec[:type]      = if column.type == :integer && [/^numeric/, /^decimal/].any? { |e| e.match(column.sql_type) }
                                 'decimal'
                               elsif uuid_sql_types.include?( column.sql_type  ) && !column.primary
                                 'uuid'
                               else
                                 column.type.to_s
                               end
            unless spec[:type] == 'uuid'
              spec[:limit]     = column.limit.inspect if column.limit != @types[column.type][:limit] && spec[:type] != 'decimal'
              spec[:precision] = column.precision.inspect if column.precision
              spec[:scale]     = column.scale.inspect if column.scale
              spec[:default]   = default_string(column.default) if column.has_default?
            end
            spec[:null]      = 'false' unless column.null
            (spec.keys - [:name, :type]).each{ |k| spec[k].insert(0, "#{k.inspect} => ")}
            spec
          end.compact

          # add PK column spec if UUID
          if pk_col && uuid_sql_types.include?( pk_col.sql_type )
            pk_spec = {}
            pk_spec[:name]      = pk_col.name.inspect

            pk_spec[:type]      = if uuid_sql_types.include?( pk_col.sql_type  )
                                    'uuid'
                                  else
                                    pk_col.type.to_s
                                  end

            pk_spec[:primary_key] = 'true'
            pk_spec[:null]      = 'false' unless pk_col.null
            pk_spec[:default]   = default_string(pk_col.default) if pk_col.has_default?
            (pk_spec.keys - [:name, :type]).each{ |k| pk_spec[k].insert(0, "#{k.inspect} => ")}
            column_specs.insert( 0, pk_spec )
          end

          # find all migration keys used in this table
          keys = [:name, :limit, :precision, :scale, :default, :null, :primary_key] & column_specs.map{ |k| k.keys }.flatten

          # figure out the lengths for each column based on above keys
          lengths = keys.map{ |key| column_specs.map{ |spec| spec[key] ? spec[key].length + 2 : 0 }.max }

          # the string we're going to sprintf our values against, with standardized column widths
          format_string = lengths.map{ |len| "%-#{len}s" }

          # find the max length for the 'type' column, which is special
          type_length = column_specs.map{ |column| column[:type].length }.max

          # add column type definition to our format string
          format_string.unshift "    t.%-#{type_length}s "

          format_string *= ''

          column_specs.each do |colspec|
            values = keys.zip(lengths).map{ |key, len| colspec.key?(key) ? colspec[key] + ", " : " " * len }
            values.unshift colspec[:type]
            tbl.print((format_string % values).gsub(/,\s*$/, ''))
            tbl.puts
          end

          tbl.puts "  end"
          tbl.puts

          indexes(table, tbl)

          tbl.rewind
          stream.print tbl.read
        rescue => e
          stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
          stream.puts "#   #{e.message}"
          stream.puts
        end

        stream
      end

  end
end

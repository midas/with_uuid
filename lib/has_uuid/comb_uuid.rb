module HasUuid
  class CombUuid

    def initialize( uuid_str )
      @uuid_str = uuid_str
    end

    def to_s
      uuid_str
    end

    def parts
      @parts ||= @uuid_str.split( '-' )
    end

    def []( idx )
      parts[idx]
    end

    def first
      parts[0]
    end

    def last
      parts[4]
    end

    def self.uuid
      # See:
      #   http://stackoverflow.com/questions/7747145/is-comb-guid-a-good-idea-with-rails-3-1-if-i-use-guids-for-primary-keys
      #   http://www.codeproject.com/Articles/32597/Performance-Comparison-Identity-x-NewId-x-NewSeque

      # MS SQL syntax: SELECT CAST(CAST(NEWID() AS BINARY(10)) + CAST(GETDATE() AS BINARY(6)) AS UNIQUEIDENTIFIER)

      # Get current Time object
      utc_timestamp = Time.now.utc

      # Convert to integer with milliseconds:  (Seconds since Epoch * 1000) + (6-digit microsecond fraction / 1000)
      utc_timestamp_with_ms_int = (utc_timestamp.tv_sec * 1000) + (utc_timestamp.tv_usec / 1000)

      # Format as hex, minimum of 12 digits, with leading zero.  Note that 12 hex digits handles to year 10889 (*).
      utc_timestamp_with_ms_hexstring = "%012x" % utc_timestamp_with_ms_int

      # If we supply UUIDTOOLS with a MAC address, it will use that rather than retrieving from system.
      # Use a regular expression to split into array, then insert ":" characters so it "looks" like a MAC address.
      UUIDTools::UUID.mac_address = (utc_timestamp_with_ms_hexstring.scan( /.{2}/ )).join(":")

      # Generate Version 1 UUID (see RFC 4122).
      uuid_str = UUIDTools::UUID.timestamp_create().to_s.upcase

      # (*) A note on maximum time handled by 6-byte timestamp that includes milliseconds:
      # If utc_timestamp_with_ms_hexstring = "FFFFFFFFFFFF" (12 F's), then
      # Time.at(Float(utc_timestamp_with_ms_hexstring.hex)/1000).utc.iso8601(10) = "10889-08-02T05:31:50.6550292968Z".

      self.new( uuid_str )
    end

  protected

    attr_reader :uuid_str

  end
end

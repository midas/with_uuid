require 'has_uuid/railtie' if defined?(Rails::Railtie)
require "has_uuid/version"
require 'schema_dumper'

module HasUuid

  autoload :CombUuid,   'has_uuid/comb_uuid'
  autoload :Extensions, 'has_uuid/extensions'
  autoload :Model,      'has_uuid/model'

end

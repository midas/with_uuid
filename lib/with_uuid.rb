require 'with_uuid/railtie' if defined?(Rails::Railtie)
require "with_uuid/version"
require 'schema_dumper'

module WithUuid

  autoload :CombUuid,   'with_uuid/comb_uuid'
  autoload :Extensions, 'with_uuid/extensions'
  autoload :Model,      'with_uuid/model'

end

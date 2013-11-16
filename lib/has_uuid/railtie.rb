require 'has_uuid'
require 'rails'

module HasUuid
  class Railtie < Rails::Railtie
    railtie_name :has_uuid

    config.to_prepare do
      HasUuid::Extensions.apply!
    end
  end
end

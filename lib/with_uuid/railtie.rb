require 'with_uuid'
require 'rails'

module WithUuid
  class Railtie < Rails::Railtie
    railtie_name :with_uuid

    config.to_prepare do
      WithUuid::Extensions.apply!
    end
  end
end

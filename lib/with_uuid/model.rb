require "active_support/concern"

module WithUuid
  module Model

	  extend ActiveSupport::Concern

	  included do

      self.primary_key = :id

      before_validation :set_id
      before_create     :set_id

	  end

  protected

    def generate_uuid
      WithUuid::CombUuid.uuid.to_s
    end

    def set_id
      return unless id.blank?

      uuid = generate_uuid
      before_set_id( uuid )
      write_attribute( :id, uuid )
      after_set_id( uuid )
    end

    def before_set_id( uuid ); end
    def after_set_id( uuid );  end

  end
end

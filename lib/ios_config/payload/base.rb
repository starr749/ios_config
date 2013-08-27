require 'securerandom'

module IOSConfig
  module Payload
    class Base

      attr_accessor :uuid, :identifier, :description

      def initialize(attributes = {})
        attributes ||= {}
        attributes.each do |name, value|
          begin
            send("#{name}=", value)
          rescue NoMethodError => e 
            raise ArgumentError, %{"#{name}" is not a valid attribute}
          end
        end

        @uuid         ||= SecureRandom.uuid
        @identifier   ||= @uuid.downcase.delete("^a-z0-9\.")
        @description  ||= ""
      end

      def build
        p = { 'PayloadType'         => payload_type,
              'PayloadVersion'      => payload_version,
              'PayloadUUID'         => @uuid,
              'PayloadIdentifier'   => @identifier,
              'PayloadDescription'  => @description }

        p.merge payload
      end

      private

      def payload_type
        raise NotImplementedError
      end

      def payload_version
        1
      end

    end
  end
end
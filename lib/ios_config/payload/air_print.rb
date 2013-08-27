module IOSConfig
  module Payload
    class AirPrint < Base

      attr_accessor :airprint # array of dictionaries with keys :ip_address and :resource_path

      private

      def payload_type
        "com.apple.airprint"
      end

      def payload
        p = {}

        if self.airprint
          p['AirPrint'] = self.airprint.collect { |i| { 'IPAddress'     => i[:ip_address],
                                                        'ResourcePath'  => i[:resource_path] }}
        end

        p
      end

    end
  end
end
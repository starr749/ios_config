module IOSConfig
  module Payload
    class AirPlay < Base

      attr_accessor :whitelist, # array of DeviceIDs
                    :passwords  # array of dictionaries with keys :device_name and :password

      private

      def payload_type
        "com.apple.airplay"
      end

      def payload_version
        0
      end

      def payload
        p = {}

        if self.whitelist
          p['Whitelist'] = self.whitelist.collect { |i| { 'DeviceID' => i } }
        end

        if self.passwords
          p['Passwords'] = self.passwords.collect { |i| { 'DeviceName' => i[:device_name],
                                                          'Password'   => i[:password] }}
        end

        p
      end

    end
  end
end
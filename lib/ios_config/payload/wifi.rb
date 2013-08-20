module IOSConfig
  module Payload
    class WiFi < Base

      ENCRYPTION_TYPES = {  :wep  => 'WEP',
                            :wpa  => 'WPA',
                            :any  => 'Any',
                            :none => 'None' }

      attr_accessor :ssid,
                    :hidden_network,  # true, false
                    :auto_join,       # true, false
                    :encryption_type, # :wep, :wpa, :any, :none
                    :password,
                    :proxy_type,      # :none, :manual, :auto
                    :proxy_server,
                    :proxy_port,
                    :proxy_username,
                    :proxy_password,
                    :proxy_url

      private

      def payload_type
        "com.apple.wifi.managed"
      end

      def payload
        p = { 'SSID_STR'        => @ssid,
              'HIDDEN_NETWORK'  => @hidden_network,
              'AutoJoin'        => @auto_join,
              'EncryptionType'  => ENCRYPTION_TYPES[@encryption_type],
              'ProxyType'       => @proxy_type.to_s.capitalize }

        p['Password'] = @password unless @password.blank?

        # Proxy

        case @proxy_type     
        when :manual
          p.merge! ({ 'ProxyServer'     => @proxy_server,
                      'ProxyServerPort' => @proxy_port })
          p['ProxyUsername'] = @proxy_username unless @proxy_username.blank?
          p['ProxyPassword'] = @proxy_password unless @proxy_password.blank?
        when :auto
          p['ProxyPACURL'] = @proxy_url
        end

        p
      end

    end
  end
end
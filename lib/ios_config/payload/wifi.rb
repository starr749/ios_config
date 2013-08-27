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
                    :is_hotspot,      # true, false
                    :domain_name,
                    :hessid,
                    :service_provider_roaming_enabled,  # true, false
                    :roaming_consortium_ois,            # array of strings
                    :nai_realm_names,                   # array of strings
                    :mcc_and_mncs,                      # array of strings
                    :displayed_operator_name,
                    :password,
                    :priority,        # integer
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
        p = { 'EncryptionType'  => ENCRYPTION_TYPES[@encryption_type] }

        
        p['AutoJoin']       = @auto_join unless @auto_join.nil?
        p['HIDDEN_NETWORK'] = @hidden_network unless @hidden_network.nil?
        p['SSID_STR']       = @ssid unless @ssid.nil?

        p['Password'] = @password unless @password.nil?
        p['Priority'] = @priority unless @priority.nil?

        # Hotspot 2.0

        p['IsHotspot'] = @is_hotspot unless @is_hotspot.nil?
        p['DomainName'] = @domain_name unless @domain_name.nil?
        p['HESSID'] = @hessid unless @hessid.nil?
        p['ServiceProviderRoamingEnabled'] = @service_provider_roaming_enabled unless @service_provider_roaming_enabled.nil?
        p['RoamingConsortiumOIs'] = @roaming_consortium_ois unless @roaming_consortium_ois.nil?
        p['NAIRealmNames'] = @nai_realm_names unless nai_realm_names.nil?
        p['MCCAndMNCs'] = @mcc_and_mncs unless @mcc_and_mncs.nil?
        p['DisplayedOperatorName'] = @displayed_operator_name unless @displayed_operator_name.nil?

        # Proxy

        p['ProxyType'] = @proxy_type.to_s.capitalize unless @proxy_type.nil?

        case @proxy_type     
        when :manual
          p.merge! ({ 'ProxyServer'     => @proxy_server,
                      'ProxyServerPort' => @proxy_port })
          p['ProxyUsername'] = @proxy_username unless @proxy_username.nil?
          p['ProxyPassword'] = @proxy_password unless @proxy_password.nil?
        when :auto
          p['ProxyPACURL'] = @proxy_url
        end

        p
      end

    end
  end
end
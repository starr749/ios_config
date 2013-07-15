module IOSConfig
  module Payload
    class VPN < Base

      attr_accessor :authentication_type, # :password, :rsa_securid
                    :connection_type,     # :l2tp, :pptp, :ipsec, :anyconnect, :juniper_ssl, :f5_ssl, :sonicwall_modile_connect, :aruba_via
                    :encryption_level,    # :none, :manual, :auto
                    :group_name,
                    :connection_name,
                    :prompt_for_password,
                    :proxy_type,          # :none, :manual, :auto
                    :proxy_port,
                    :proxy_server,
                    :send_all_traffic,
                    :server,
                    :proxy_url,
                    :group_or_domain,
                    :password,
                    :username,
                    :proxy_password,
                    :proxy_username,
                    :realm,
                    :role,
                    :shared_secret

      private

      def payload_type
        "com.apple.vpn.managed"
      end

      def payload
        p = { 'UserDefinedName' => @connection_name,
              'IPv4'            => { 'OverridePrimary' => 1 } }

        # Connection Type Specifics

        case @connection_type
        when :l2tp
          p['VPNType'] = 'L2TP'
          p_ipsec = { 'AuthenticationMethod'  => 'SharedSecret',
                      'LocalIdentifierType'   => 'KeyID' }
          p_ipsec['SharedSecret'] = StringIO.new(@shared_secret) unless @shared_secret.blank?
          p['IPSec']  = p_ipsec
          p['PPP']    = generate_ppp_config
      
        when :pptp
          p['VPNType'] = 'PPTP'
          p['PPP'] = generate_ppp_config.merge({  'CPPEnabled'        => @encryption_level != :none,
                                                  'CCPMPPE128Enabled' => @encryption_level != :none,
                                                  'CCPMPPE40Enabled'  => @encryption_level == :auto,
                                                  'CommRemoteAddress' => @server })

        when :ipsec
          p['VPNType'] = 'IPSec'
          p_ipsec = { 'AuthenticationMethod'  => 'SharedSecret',
                      'LocalIdentifierType'   => 'KeyID',
                      'RemoteAddress'         => @server }
          p_ipsec['LocalIdentifier'] = @group_name unless @group_name.blank?
          p_ipsec['SharedSecret']    = StringIO.new(@shared_secret) unless @shared_secret.blank?
          unless @username.blank?
            p_ipsec['XAuthEnabled'] = 1
            p_ipsec['XAuthName']    = @username
          end
          p_ipsec['XAuthPasswordEncryption'] = 'Prompt' unless @prompt_for_password.blank?
          p['IPSec'] = p_ipsec

        when :anyconnect
          p['VPNType']      = 'VPN'
          p['VPNSubType']   = 'com.cisco.anyconnect.applevpn.plugin'
          p['VendorConfig'] = @group_name.blank? ? {} : { 'Group' => @group_name }
          p['VPN']          = generate_vpn_config

        when :juniper_ssl
          p['VPNType']    = 'VPN'
          p['VPNSubType'] = 'net.juniper.sslvpn'
          vendor_config   = {}
          vendor_config['Realm']  = @realm unless @realm.blank?
          vendor_config['Role']   = @role unless @role.blank?
          p['VendorConfig'] = vendor_config
          p['VPN']          = generate_vpn_config
          
        when :f5_ssl
          p['VPNType']      = 'VPN'
          p['VPNSubType']   = 'com.f5.F5-Edge-Client.vpnplugin'
          p['VPN']          = generate_vpn_config
          p['VendorConfig'] = {}

        when :sonicwall_mobile_connect
          p['VPNType']      = 'VPN'
          p['VPNSubType']   = 'com.sonicwall.SonicWALL-SSLVPN.vpnplugin'
          p['VendorConfig'] = @group_or_domain.blank? ? {} : { 'LoginGroupOrDomain' => @group_or_domain }
          p['VPN']          = generate_vpn_config

        when :aruba_via
          p['VPNType']      = 'VPN'
          p['VPNSubType']   = 'com.arubanetworks.aruba-via.vpnplugin'
          p['VendorConfig'] = {}
        end

        # Send All Traffic

        p['OverridePrimary'] = 1 if @send_all_traffic == true

        # Proxy

        case @proxy_type
        when :none
          p_proxy = {}
        
        when :manual
          p_proxy = { 'HTTPEnable'  => 1,
                      'HTTPPort'    => @proxy_port,
                      'HTTPProxy'   => @proxy_server,
                      'HTTPSEnable' => 1,
                      'HTTPSPort'   => @proxy_port,
                      'HTTPSProxy'  => @proxy_server }

          p_proxy['HTTPProxyUsername'] = @proxy_username unless @proxy_username.blank?
          p_proxy['HTTPProxyPassword'] = @proxy_password unless @proxy_password.blank?
        
        when :auto
          p_proxy = { 'ProxyAutoConfigEnable'     => 1,
                      'ProxyAutoConfigURLString'  => @proxy_url }
        
        end
        p['Proxies'] = p_proxy

        p
      end

      def generate_ppp_config
        p_ppp = { 'CommRemoteAddress' => @server }
        if @authentication_type == :password
          p_ppp['AuthName']      = @username unless @username.blank?
          p_ppp['AuthPassword']  = @password unless @password.blank?
        else
          p_ppp['AuthEAPPlugins'] = ['EAP-RSA']
          p_ppp['AuthProtocol']   = ['EAP']
        end

        p_ppp
      end

      def generate_vpn_config
        p_vpn = { 'AuthenticationMethod'  => 'Password',
                  'RemoteAddress'         => @server }
        p_vpn['AuthName']     = @username unless @username.blank?
        p_vpn['AuthPassword'] = @password unless @password.blank?

        p_vpn
      end
    end
  end
end
module IOSConfig
	module Payload
		class CardDAV < Base

			attr_accessor 	:host_name, 	# The server Address
							:account_description,
							:username,
							:password,
							:use_ssl, 		# true, false
							:port, 			# Number, Optional
							:cal_principal_url	# Optional, base url to calandar

			private

			def payload_type
				"com.apple.carddav.account"
			end

			def payload
				p = {}

				p['CardDAVAccountDescription'] = @account_description unless @account_description.nil?
				p['CardDAVHostName'] = @host_name unless @host_name.nil?
				p['CardDAVUsername'] = @username unless @username.nil?
				p['CardDAVPassword'] = @password unless @password.nil?
				p['CardDAVUseSSL'] = @use_ssl unless @use_ssl.nil?
				p['CardDAVPort'] = @port unless @port.nil?
				p['CalDAVPrincipalURL'] = @cal_principal_url unless @cal_principal_url.nil?

				p
			end
			
		end
	end
end
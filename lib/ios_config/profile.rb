require 'cfpropertylist'

module IOSConfig
  class Profile
    require 'openssl'

    attr_accessor :allow_removal, # if profile can be deleted by device user. defaults to true
                  :description,   # (optional) displayed in device settings 
                  :display_name,  # displayed in device settings
                  :identifier,
                  :organization,  # (optional) displayed in device settings
                  :type,          # (optional) default is 'Configuration'
                  :uuid,
                  :version,       # (optional) defaults to '1'
                  :payloads,      # (optional) payloads to be contained in the profile. should be an array if type is 'Configuration'
                  :client_certs   # (optional) certificates used to encypt payloads

    def initialize(options = {})
      options.each { |k,v| self.send("#{k}=", v) }
      puts self.allow_removal
      puts self.allow_removal.nil?
      self.allow_removal  = true if self.allow_removal.nil?
      self.type           ||= 'Configuration'
      self.version        ||= 1
      self.payloads       ||= []
    end
  
    def signed(mdm_cert, mdm_intermediate_cert, mdm_private_key)
      certificate   = OpenSSL::X509::Certificate.new(File.read(mdm_cert))
      intermediate  = OpenSSL::X509::Certificate.new(File.read(mdm_intermediate_cert))
      private_key   = OpenSSL::PKey::RSA.new(File.read(mdm_private_key))
    
      signed_profile = OpenSSL::PKCS7.sign(certificate, private_key, unsigned, [intermediate], OpenSSL::PKCS7::BINARY)
      signed_profile.to_der
    end
  
    private
  
    def unsigned
      raise_if_blank [:version, :uuid, :type, :identifier, :display_name]
    
      profile = {
        'PayloadDisplayName'        => self.display_name,
        'PayloadVersion'            => self.version,
        'PayloadUUID'               => self.uuid,
        'PayloadIdentifier'         => self.identifier,
        'PayloadType'               => self.type,
        'PayloadRemovalDisallowed'  => !self.allow_removal
      }
      profile['PayloadOrganization']  = self.organization if self.organization
      profile['PayloadDescription']   = self.description  if self.description
          
      if self.client_certs.nil?
        profile['PayloadContent'] = payloads
      else
        encrypted_payload_content = OpenSSL::PKCS7.encrypt( self.client_certs, 
                                                            payloads.to_plist, 
                                                            OpenSSL::Cipher::Cipher::new("des-ede3-cbc"), 
                                                            OpenSSL::PKCS7::BINARY)
      
        profile['EncryptedPayloadContent'] = StringIO.new encrypted_payload_content.to_der
      end

      profile.to_plist
    end
  
    def raise_if_blank(required_attributes)
      required_attributes.each { |a| raise "#{a} must be set" if self.send(a).blank? }
    end
    
  end

end
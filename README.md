# ios_config

This gem provides an easy way to generate profiles and configuration payloads for use with Apple iOS devices. These profiles and payloads can be delivered via Apple MDM or Apple's Configurator or iPhone Configuration Utility (IPCU).

Not all of the possible configuration payloads have been implemented yet. Some options may be missing. If you need a particular payload or need additional support from an existing payload, please fork and implement it so that we can all benefit from your efforts!

## Installation

Add this line to your application's Gemfile:

    gem 'ios_config'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ios_config

## Usage

Profiles contain basic identification and labeling information in addition to a collection of payloads. When you use this gem, you'll want to do two things:

1. Create your payloads
2. Create a profile that includes your payloads

### Example

Here is an example of how you might do this:

```ruby
# Create a payload

vpn_payload = IOSConfig::Payload::VPN.new connection_name:     "My VPN",
                                          authentication_type: :password,
                                          connection_type:     :pptp,
                                          encryption_level:    :auto,
                                          proxy_type:          :none,
                                          send_all_traffic?    true,
                                          server:              "example.org",
                                          username:            "macdemarco",
                                          password:            "viceroy"

payloads = [vpn_payload.build]

# Create a profile instance

profile = IOSConfig::Profile.new type:           "Configuration",
                                 display_name:   "A Profile Name",
                                 identifier:     "org.example.examplemdmservice.exampleprofile",
                                 organization:   "A Company Name",
                                 uuid:           SecureRandom.uuid,
                                 allow_removal:  false,
                                 client_certs:   [OpenSSL::X509::Certificate.new], # Array of client certificates
                                 payloads:       payloads # must be an array when type is "Configuration" 


# Generate a plist version of the profile, ready for delivery to the device

unsigned_profile = profile.unsigned

# Or, generate a signed plist version of the profile

signed_profile = profile.signed( signing_cert_path,
                                 signing_cert_intermediate_path
                                 signing_cert_key_path )
```

### Profile

```ruby
# Create the profile

profile = IOSConfig::Profile.new [parameters]

# Then, generate your config one of two ways:

profile_plist = profile.unsigned # OR
profile_plist = profile.signed( [signing_cert_path], [intermediate_path], [key_path] )
```

#### Parameters

```ruby
allow_removal # if profile can be deleted by device user. defaults to true
description   # (optional) displayed in device settings 
display_name  # displayed in device settings
identifier
organization  # (optional) displayed in device settings
type          # (optional) default is 'Configuration'
uuid
version       # (optional) defaults to '1'
payloads      # (optional) payloads to be contained in the profile. should be an array if type is 'Configuration'
client_certs  # (optional) certificates used to encypt payloads
```

### Payloads

#### Common Parameters

```ruby
uuid
identifier
description
```

#### VPN

```ruby
payload = IOSConfig::Payload::VPN.new(parameters).build
```

Available parameters:

```ruby
connection_name    
authentication_type  # :password, :rsa_securid
connection_type      # :l2tp, :pptp, :ipsec, :anyconnect, :juniper_ssl, :f5_ssl, :sonicwall_modile_connect, :aruba_via
encryption_level     # :none, :manual, :auto
group_name           
prompt_for_password  # true, false
proxy_type           # :none, :manual, :auto
proxy_port          
proxy_server        
send_all_traffic     # true, false
server               
proxy_url            
group_or_domain      
password             
username             
proxy_password      
proxy_username       
realm     
role             
shared_secret      
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

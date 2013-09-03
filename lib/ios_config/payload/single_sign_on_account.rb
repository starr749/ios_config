module IOSConfig
  module Payload
    class SingleSignOnAccount < Base

      attr_accessor :name,
                    :principal_name,
                    :realm,
                    :url_prefix_matches,    # array of strings
                    :app_identifier_matches # array of strings

      private

      def payload_type
        "com.apple.sso"
      end

      def payload
        p = { 'Name'      => @name,
              'Kerberos'  => { 'Realm' => @realm } }

        p['Kerberos']['PrincipalName']        = @principal_name         if @principal_name
        p['Kerberos']['URLPrefixMatches']     = @url_prefix_matches     if @url_prefix_matches
        p['Kerberos']['AppIdentifierMatches'] = @app_identifier_matches if @app_identifier_matches

        p
      end

    end
  end
end
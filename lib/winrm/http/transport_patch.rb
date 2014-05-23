module WinRM
  module HTTP

    class HttpSSPINegotiate < HttpTransport
      def initialize(endpoint, user, pass, opts)
        # Override the relevant functionality in httpclient to make sspi work.
        require 'winrm/http/auth'
        super(endpoint)
        @httpcli.set_auth(nil, user, pass)
        # Remove non-sspi auths
        auths = @httpcli.www_auth.instance_variable_get('@authenticator')
        auths.delete_if {|i| not i.is_a?(HTTPClient::SSPINegotiateAuth)}
      end
    end

  end
end # WinRM

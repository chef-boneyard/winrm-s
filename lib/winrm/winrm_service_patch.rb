
require 'winrm/http/transport_patch'

module WinRM
  class WinRMWebService

    # Override winrm to support sspinegotiate option.

    # @param [String,URI] endpoint the WinRM webservice endpoint
    # @param [Symbol] transport either :kerberos(default)/:ssl/:plaintext
    # @param [Hash] opts Misc opts for the various transports.
    #   @see WinRM::HTTP::HttpTransport
    #   @see WinRM::HTTP::HttpGSSAPI
    #   @see WinRM::HTTP::HttpSSL
    def initialize(endpoint, transport = :kerberos, opts = {})
      @endpoint = endpoint
      @timeout = DEFAULT_TIMEOUT
      @max_env_sz = DEFAULT_MAX_ENV_SIZE 
      @locale = DEFAULT_LOCALE
      case transport
      when :kerberos
        require 'gssapi'
        # TODO: check fo keys and throw error if missing
        @xfer = HTTP::HttpGSSAPI.new(endpoint, opts[:realm], opts[:service], opts[:keytab], opts)
      when :plaintext
        @xfer = HTTP::HttpPlaintext.new(endpoint, opts[:user], opts[:pass], opts)
      when :sspinegotiate
        @xfer = HTTP::HttpSSPINegotiate.new(endpoint, opts[:user], opts[:pass], opts)
      when :ssl
        @xfer = HTTP::HttpSSL.new(endpoint, opts[:user], opts[:pass], opts[:ca_trust_path], opts)
      end
    end
  end
end
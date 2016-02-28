
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
      @logger = Logging.logger[self]
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
      when :negotiate
        @xfer = HTTP::HttpNegotiate.new(endpoint, opts[:user], opts[:pass], opts)
      end
    end

    # Get the builder obj for output request
    # @param [String] shell_id The shell id on the remote machine.  See #open_shell
    # @param [String] command_id The command id on the remote machine.  See #run_command
    # @return [Builder::XmlMarkup] Returns a Builder::XmlMarkup for request message 
    def get_builder_obj(shell_id, command_id, &block)
      body = { "#{NS_WIN_SHELL}:DesiredStream" => 'stdout stderr',
        :attributes! => {"#{NS_WIN_SHELL}:DesiredStream" => {'CommandId' => command_id}}}
      builder = Builder::XmlMarkup.new
      builder.instruct!(:xml, :encoding => 'UTF-8')
      builder.tag! :env, :Envelope, namespaces do |env|
        env.tag!(:env, :Header) { |h| h << Gyoku.xml(merge_headers(header,resource_uri_cmd,action_receive,selector_shell_id(shell_id))) }
        env.tag!(:env, :Body) do |env_body|
          env_body.tag!("#{NS_WIN_SHELL}:Receive") { |cl| cl << Gyoku.xml(body) }
        end
      end
      builder
    end

    # Get the Output of the given shell and command
    # @param [String] shell_id The shell id on the remote machine.  See #open_shell
    # @param [String] command_id The command id on the remote machine.  See #run_command
    # @return [Hash] Returns a Hash with a key :exitcode and :data.  Data is an Array of Hashes where the cooresponding key
    #   is either :stdout or :stderr.  The reason it is in an Array so so we can get the output in the order it ocurrs on
    #   the console.
    def get_command_output(shell_id, command_id, &block)
      done_elems = []
      output = Output.new

      while done_elems.empty?
        resp_doc = nil
        builder = get_builder_obj(shell_id, command_id, &block)
        request_msg = builder.target!
        resp_doc = send_get_output_message(request_msg)

        REXML::XPath.match(resp_doc, "//#{NS_WIN_SHELL}:Stream").each do |n|
          next if n.text.nil? || n.text.empty?
          stream = { n.attributes['Name'].to_sym => Base64.decode64(n.text).force_encoding('utf-8').sub("\xEF\xBB\xBF", "") }
          output[:data] << stream
          yield stream[:stdout], stream[:stderr] if block_given?
        end

        # We may need to get additional output if the stream has not finished.
        # The CommandState will change from Running to Done like so:
        # @example
        #   from...
        #   <rsp:CommandState CommandId="..." State="http://schemas.microsoft.com/wbem/wsman/1/windows/shell/CommandState/Running"/>
        #   to...
        #   <rsp:CommandState CommandId="..." State="http://schemas.microsoft.com/wbem/wsman/1/windows/shell/CommandState/Done">
        #     <rsp:ExitCode>0</rsp:ExitCode>
        #   </rsp:CommandState>
        done_elems = REXML::XPath.match(resp_doc, "//*[@State='http://schemas.microsoft.com/wbem/wsman/1/windows/shell/CommandState/Done']")
      end
      output[:exitcode] = REXML::XPath.first(resp_doc, "//#{NS_WIN_SHELL}:ExitCode").text.to_i
      output
    end
  end
end
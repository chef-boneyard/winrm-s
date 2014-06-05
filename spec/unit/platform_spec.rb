require 'spec_helper'


describe "Test if patch is applied on Platform" do
  before do
    @winrm = WinRM::WinRMWebService.new("http://mywinrmhost:5985/wsman", :sspinegotiate, :user => "test_winrm_user", :pass => "test_winrm_pass")
  end

  describe 'Windows is succesfully patched for transport sspinegotiate', :windows_only do

    it 'HTTP::HttpSSPINegotiate class should exists' do
      expect{WinRM::HTTP::HttpSSPINegotiate}.not_to raise_exception
    end

    it 'should patch httpclient to contain encrypt/decrypt methods' do
      expect(HTTPClient::SSPINegotiateAuth.new).to respond_to(:encrypt_payload)
      expect(HTTPClient::SSPINegotiateAuth.new).to respond_to(:decrypt_payload)
    end

  end

  describe 'Unix is not patched for transport sspinegotiate', :unix_only do

    it 'HTTP::HttpSSPINegotiate class should not exists' do
      expect{WinRM::HTTP::HttpSSPINegotiate}.to raise_exception
    end

    it 'should NOT patch httpclient to contain encrypt/decrypt methods' do
      expect(HTTPClient::SSPINegotiateAuth.new).not_to respond_to(:encrypt_payload)
      expect(HTTPClient::SSPINegotiateAuth.new).not_to respond_to(:decrypt_payload)
    end
  end

end
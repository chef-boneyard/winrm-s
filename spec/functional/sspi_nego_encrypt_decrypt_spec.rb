require 'spec_helper'

if windows?
  ["test_winrm_endpoint", "test_winrm_user", "test_winrm_pass"].each do |env_var|
    raise "\n\nError: Please set the environment variable: #{env_var}\n\n" if ENV[env_var].nil?
  end
end

describe "Test sspinegotiate with encrypt/decrypt via WinRM", :windows_only do
  before do
    %x{winrm set winrm/config/service @{AllowUnencrypted="false"}}
    @winrm = WinRM::WinRMWebService.new(ENV["test_winrm_endpoint"], :sspinegotiate, :user => ENV["test_winrm_user"], :pass => ENV["test_winrm_pass"])
  end

  after do
    %x{winrm set winrm/config/service @{AllowUnencrypted="true"}}
  end

  it 'should run a CMD command string' do
    output = @winrm.run_cmd('ipconfig /all')
    expect(output[:exitcode]).to be_zero
    expect(output[:data]).not_to be_empty
  end

  it 'should run a CMD command with proper arguments' do
    output = @winrm.run_cmd('ipconfig', %w{/all})
    expect(output[:exitcode]).to be_zero
    expect(output[:data]).not_to be_empty
  end

  it 'should run a CMD command with block' do
    outvar = ''
    @winrm.run_cmd('ipconfig', %w{/all}) do |stdout, stderr|
      outvar << stdout
    end
    expect(outvar).to match(/Windows IP Configuration/)
  end

  describe "Negative test:" do
    before do
      %x{winrm set winrm/config/service @{AllowUnencrypted="true"}}
    end
    after do
      %x{winrm set winrm/config/service @{AllowUnencrypted="false"}}
    end

    describe "when AllowUnencrypted is set to true" do
      it "should raise an exception" do
        expect{@winrm.run_cmd('ipconfig')}.to raise_exception
      end
    end
  end
end
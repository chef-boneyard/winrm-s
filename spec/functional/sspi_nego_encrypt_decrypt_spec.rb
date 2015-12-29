require 'spec_helper'

def assert_prerequisites
  if windows?
    require 'winrm-s'
    ["test_winrm_endpoint", "test_winrm_user", "test_winrm_pass"].each do |env_var|
      raise "\n\nError: Please set the environment variable: #{env_var}\n\n" if ENV[env_var].nil?
    end
  end
end


describe "Test sspinegotiate with encrypt/decrypt via WinRM" do
  before(:all) do
    assert_prerequisites
    # Remember the user setting.
    winrm_cfg = %x{winrm get winrm/config/service -format:xml}
    doc = Nokogiri::XML(winrm_cfg)
    @original_allowunencrypted_val = doc.at_css("cfg|Service cfg|AllowUnencrypted").text.to_s
  end

  before do
    %x{winrm set winrm/config/service @{AllowUnencrypted="false"}}
    @winrm = WinRM::WinRMWebService.new(ENV["test_winrm_endpoint"], :sspinegotiate, :user => ENV["test_winrm_user"].dup, :pass => ENV["test_winrm_pass"].dup)
  end

  after(:all) do
    %x{winrm set winrm/config/service @{AllowUnencrypted="#{@original_allowunencrypted_val}"}}
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
end

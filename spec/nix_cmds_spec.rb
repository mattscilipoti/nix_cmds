RSpec.describe NixCmds do
  it 'has a version number' do
    expect(NixCmds::VERSION).to be_a(Gem::Version)
    expect(NixCmds::VERSION).to be >= Gem::Version.new('0.1.0')
  end
end

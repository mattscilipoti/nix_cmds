# frozen_string_literal: true

require_relative '../lib/nix_cmds/nix_cmd'
require_relative 'shared_examples_for_all_nix_cmds'

RSpec.describe NixCmds::NixCmd do
  subject(:base_cmd) do
    cmd = NixCmds::NixCmd.new(
      logger: test_logger
    )
    # disable actual base_cmd call
    allow(cmd).to receive(:_perform_command).and_return(SpecHelper.result_successful)
    cmd
  end

  let(:test_logger) do
    double('Logger').tap do |logger|
      allow(logger).to receive(:debug)
      allow(logger).to receive(:info)
    end
  end

  it_behaves_like 'all NixCmds'

  describe '(defaults)' do
    it 'should NOT implement #cmd' do
      expect { base_cmd.cmd }.to raise_error(NotImplementedError, /child/)
    end
  end
end

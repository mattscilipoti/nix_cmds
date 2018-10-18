# frozen_string_literal: true

require_relative 'shared_examples_for_all_nix_cmds'

RSpec.describe NixCmds::RsyncCmd do
  subject(:rsync) do
    cmd = NixCmds::RsyncCmd.new(
      logger: test_logger
    )
    # disable actual rsync call
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
    its(:cmd) { should eq 'rsync' }
  end
end

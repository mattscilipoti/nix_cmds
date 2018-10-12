# frozen_string_literal: true

RSpec.describe NixCmds::RsyncCmd do
  subject(:rsync) do
    cmd = NixCmds::RsyncCmd.new(
      logger: test_logger
    )
    # disable actual rsync call
    allow(cmd).to receive(:_perform_command).and_return(result_successful)
    cmd
  end

  let(:test_logger) do
    double('Logger').tap do |logger|
      allow(logger).to receive(:debug)
      allow(logger).to receive(:info)
    end
  end

  let(:result_failure) do
    NixCmds::CommandResult.new(
      exit_code: 1,
      stderr: 'FAILED'
    )
  end

  let(:result_successful) do
    NixCmds::CommandResult.new(
      exit_code: 0,
      stdout: 'SUCCESS!'
    )
  end

  describe '(defaults)' do
    its(:cmd) { should eq 'rsync' }
    its(:cmd_args) { should match_array ['--dry-run'] }
    its(:dry_run) { should be true }
    its(:logger) { should be test_logger }
  end

  describe '#run' do
    let(:expected_args) { ['--dry-run', 'a/', 'b/'] }
    it 'should return a CommandResult' do
      expect(
        subject.run(source_dir: 'foo', destination_dir: 'bar')
      ).to be_a(NixCmds::CommandResult)
    end

    it 'should call _perform_commmand with rsync and args' do
      expect(subject).to receive(:_perform_command).with('rsync', expected_args)
      subject.run(source_dir: 'a', destination_dir: 'b')
    end

    it 'should log Running cmd (as debug) ' do
      expect(test_logger).to receive(:debug).with("Running 'rsync --dry-run c/ d/'")
      subject.run(source_dir: 'c', destination_dir: 'd')
    end

    it 'should log Completed w/result (as :info)' do
      expect(test_logger).to receive(:info).with("Completed rsync. #{result_successful}")
      subject.run(source_dir: 'e', destination_dir: 'f')
    end

    describe '(on failure)' do
      before(:each) do
        expect(rsync).to receive(:_perform_command).and_return(result_failure)
        allow(test_logger).to receive(:error)
      end

      it 'should log Completed w/result (as :info)' do
        expect(test_logger).to receive(:info).with("Completed rsync. #{result_failure}")
        subject.run(source_dir: 'bad', destination_dir: 'worse')
      end

      it 'should log the stderr (as :error)' do
        expect(test_logger).to receive(:error).with(result_failure.stderr)
        subject.run(source_dir: 'bad', destination_dir: 'worse')
      end
    end
  end
end

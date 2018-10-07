require_relative '../lib/nix_cmds/command_result'

RSpec.describe NixCmds::CommandResult do
  describe '(constructor)' do
    it 'requires exit_code' do
      expect { NixCmds::CommandResult.new }.to raise_error(ArgumentError, /missing keyword.*exit_code/)
    end

    it 'accepts stderr' do
      expect(
        NixCmds::CommandResult.new(
          exit_code: 0,
          stderr: 'TEST STDERR'
        ).stderr
      ).to eql('TEST STDERR')
    end

    it 'accepts stdout' do
      expect(
        NixCmds::CommandResult.new(
          exit_code: 0,
          stdout: 'TEST STDOUT'
        ).stdout
      ).to eql('TEST STDOUT')
    end
  end

  describe '#success' do
    it 'is true when exit_code==0' do
      expect(
        NixCmds::CommandResult.new(exit_code: 0).success?
      ).to be true
    end

    it 'is false when exit_code!=0' do
      expect(
        NixCmds::CommandResult.new(exit_code: 1).success?
      ).to be false
    end
  end

  describe '#to_s' do
    context '(when successful)' do
      subject(:cmd) do
        NixCmds::CommandResult.new(
          exit_code: 0,
          stdout: 'TEST STDOUT'
        )
      end

      it 'indicates "Success", when success' do
        expect(subject.to_s).to match(/^Success/)
      end

      it 'includes STDOUT, when exists' do
        expect(subject.to_s).to match(/STDOUT:.+"TEST STDOUT"/m)
      end

      it 'does NOT include STDOUT, when stdout is blank' do
        subject.stdout = ''
        expect(subject.to_s).to_not match(/STDOUT/)
      end

      it 'does NOT include STDERR' do
        expect(subject.to_s).to_not match(/STDERR/)
      end
    end

    context '(when failure)' do
      subject(:cmd) do
        NixCmds::CommandResult.new(
          exit_code: 1,
          stderr: "TEST STDERR\nSAMPLE BACK TRACE"
        )
      end

      it 'indicates "FAILED", when not success' do
        expect(subject.to_s).to match(/^FAILED/)
      end

      it 'includes STDERR' do
        expect(subject.to_s).to match(/STDERR:\s"TEST STDERR.+SAMPLE BACK TRACE"/m)
      end

      it 'includes STDERR, even if empty' do
        subject.stderr = ''
        expect(subject.to_s).to match(/STDERR:\s""/m)
      end
    end
  end
end

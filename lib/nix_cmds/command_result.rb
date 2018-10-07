class NixCmds::CommandResult
  attr_accessor :exit_code, :stderr, :stdout

  def initialize(exit_code:, stderr: '', stdout: '', pid: nil)
    @pid = pid
    @exit_code = exit_code
    @stderr = stderr
    @stdout = stdout
  end

  def success?
    exit_code == 0
  end

  def to_s
    msg = success? ? 'Success' : 'FAILED'
    msg += ", STDOUT:\n#{stdout.inspect}" unless stdout.to_s.strip.empty?
    msg += ", STDERR:\n#{stderr.inspect}" unless success?
    msg
  end
end

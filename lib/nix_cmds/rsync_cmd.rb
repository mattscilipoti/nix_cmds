# frozen_string_literal: true

require_relative 'command_result'
require 'open3'

module NixCmds
  # wraps rsync command (to remote server)
  # returns CommandResult
  class RsyncCmd
    attr_accessor :dry_run, :logger
    attr_reader :result

    def initialize(logger:, dry_run: true)
      @cmd_args = []
      @dry_run = dry_run
      @logger = logger
    end

    def cmd
      'rsync'
    end

    def cmd_args
      @cmd_args = @cmd_args.prepend('--dry-run') if dry_run && !@cmd_args.include?('--dry-run') # show what would have been transferred
      @cmd_args
    end

    def run(source_dir:, destination_dir:)
      cmd_args << "#{source_dir}/"
      cmd_args << "#{destination_dir}/"

      logger.debug "Running '#{self}'"
      result = _perform_command(cmd, cmd_args)

      @result = result

      msg = "Completed #{cmd}. #{result}"
      logger.info msg
      logger.error(result.stderr) unless result.success?

      result
    end

    def run!(source_dir, destination_dir, cmd_args = {})
      result = run(source_dir, destination_dir, cmd_args)
      raise result.stderr unless result.success?
      result
    end

    def to_s
      "#{cmd} #{cmd_args.join(' ')}"
    end

    private

    def _perform_command(cmd, cmd_args)
      stdout, stderr, status = Open3.capture3(cmd, *cmd_args)

      CommandResult.new(
        exit_code: status.exitstatus,
        pid: status.pid,
        stderr: stderr,
        stdout: stdout
      )
    end
  end
end

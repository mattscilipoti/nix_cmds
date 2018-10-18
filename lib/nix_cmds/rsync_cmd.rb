# frozen_string_literal: true

require_relative 'nix_cmd'

module NixCmds
  # wraps rsync command (to remote server)
  # returns CommandResult
  class RsyncCmd < NixCmd
    def executable
      'rsync'
    end
  end
end

# frozen_string_literal: true

require_relative 'nix_cmd'

module NixCmds
  # wraps rsync command (to remote server)
  # returns CommandResult
  class RsyncCmd < NixCmd
    def cmd
      'rsync'
    end
  end
end

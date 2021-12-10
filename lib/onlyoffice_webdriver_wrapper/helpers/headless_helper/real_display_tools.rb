# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # module for getting info about real display
  module RealDisplayTools
    # @return [String] result of `xrandr` command output
    def xrandr_result
      result = `xrandr 2>&1`
      OnlyofficeLoggerHelper.log("xrandr answer: #{result}".delete("\n"))
      result
    end

    # Check if any real display connected to system
    # @return [Boolean] result of this check
    def real_display_connected?
      return true if OSHelper.mac?

      result = xrandr_result
      exists = result.include?(' connected') && !result.include?('Failed')
      OnlyofficeLoggerHelper.log("Real Display Exists: #{exists}")
      exists
    end
  end
end

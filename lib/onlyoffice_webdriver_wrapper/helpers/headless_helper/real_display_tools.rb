# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # module for getting info about real display
  module RealDisplayTools
    def xrandr_result
      result = `xrandr 2>&1`
      OnlyofficeLoggerHelper.log("xrandr answer: #{result}".delete("\n"))
      result
    end

    def real_display_connected?
      return true if OSHelper.mac?

      result = xrandr_result
      exists = result.include?(' connected') && !result.include?('Failed')
      OnlyofficeLoggerHelper.log("Real Display Exists: #{exists}")
      exists
    end
  end
end

module OnlyofficeWebdriverWrapper
  module RealDisplayTools
    def xrandr_result
      begin
        result = `xrandr`
      rescue Exception
        result = 'xrandr throw an exception'
      end
      OnlyofficeLoggerHelper.log("xrandr answer: #{result}".delete("\n"))
      result
    end

    def real_display_connected?
      return true if OSHelper.mac?
      result = xrandr_result
      exists = result.include?(' connected') # sometimes there is 'disconnected' so need a space before 'connected'
      OnlyofficeLoggerHelper.log("Real Display Exists: #{exists}")
      exists
    end
  end
end

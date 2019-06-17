# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Module for working with browser metadata
  module WebdriverBrowserInfo
    # @return [Dimensions] Size of browser window
    def browser_size
      size_struct = @driver.manage.window.size
      size = Dimensions.new(size_struct.width, size_struct.height)
      OnlyofficeLoggerHelper.log("browser_size: #{size}")
      size
    end

    # @return [String] info about platform
    def browser_metadata
      caps = @driver.capabilities
      platform = caps[:platform_name] || caps[:platform]
      version = caps[:browser_version] || caps[:version]
      "Platform: #{platform}, Browser: #{caps[:browser_name]}, Version: #{version}"
    end
  end
end

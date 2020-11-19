# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for getting chrome version
  module ChromeVersionHelper
    # @return [Gem::Version] unknown chrome version
    def unknown_chrome_version
      Gem::Version.new('0.0.0.0')
    end

    # @return [Gem::Version] version of chrome. Gem::Version.new(0, 0, 0, 0) if unknown
    def chrome_version(chrome_command = 'google-chrome')
      version = `#{chrome_command} --product-version`
      OnlyofficeLoggerHelper.log("Chrome Version is: #{version}")
      Gem::Version.new(version)
    rescue StandardError => e
      OnlyofficeLoggerHelper.log("Cannot get chrome version because of: #{e}")
      unknown_chrome_version
    end
  end
end

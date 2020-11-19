# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for getting chrome version
  module ChromeVersionHelper
    # @return [Integer] current default chrome version
    CURRENT_DEFAULT_CHROME_VERSION = 87

    # @return [Gem::Version] version of chrome. Return unknown_chrome_version if cannot get
    def chrome_version(chrome_command = 'google-chrome')
      return @chrome_version if @chrome_version

      @chrome_version = `#{chrome_command} --product-version`
      OnlyofficeLoggerHelper.log("Chrome Version is: #{@chrome_version}")
      @chrome_version = Gem::Version.new(@chrome_version)
    rescue StandardError => e
      OnlyofficeLoggerHelper.log("Cannot get chrome version because of: #{e}")
      @chrome_version = unknown_chrome_version
    end

    # @return [String] path to chromedriver
    def chromedriver_path
      return default_mac if OSHelper.mac?
      return default_linux if chrome_version == unknown_chrome_version

      chromedriver_path_cur_chrome
    end

    private

    # @return [Gem::Version] unknown chrome version
    def unknown_chrome_version
      Gem::Version.new('0.0.0.0')
    end

    # @return [String] default mac chromedriver
    def default_mac
      "#{Dir.pwd}/lib/onlyoffice_webdriver_wrapper/helpers/bin/chromedriver_mac"
    end

    # @return [String] default linux chromedriver
    def default_linux
      "#{Dir.pwd}/lib/onlyoffice_webdriver_wrapper/helpers/bin/chromedriver_linux_#{CURRENT_DEFAULT_CHROME_VERSION}"
    end

    # @return [String] path to chromedriver of version
    def chromedriver_path_cur_chrome
      file_path = "#{Dir.pwd}/lib/onlyoffice_webdriver_wrapper/helpers/bin/chromedriver_linux_#{chrome_version.segments.first}"

      return file_path if File.exist?(file_path)

      OnlyofficeLoggerHelper.log("Cannot file chromedriver by version #{chrome_version.version}. Using Default")
      default_linux
    end
  end
end

# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for getting chrome version
  module ChromeVersionHelper
    # @return [Gem::Version] unknown chrome version
    def unknown_chrome_version
      Gem::Version.new('0.0.0.0')
    end

    # @return [Gem::Version] version of chrome. Return unknown_chrome_version if cannot get
    def chrome_version(chrome_command = 'google-chrome')
      return @chrome_version if @chrome_version

      version_string = `#{chrome_command} --product-version`
      OnlyofficeLoggerHelper.log("Chrome Version is: #{version_string}")
      @chrome_version = Gem::Version.new(version_string)
    rescue StandardError => e
      OnlyofficeLoggerHelper.log("Cannot get chrome version because of: #{e}")
      @chrome_version = unknown_chrome_version
    end

    # @param [Symbol] force_os force OS for chrome version (`:linux` or `:mac`),
    #   if empty - will try to autodetect current os
    # @return [String] path to chromedriver
    def chromedriver_path(force_os = nil)
      return default_mac if OSHelper.mac? || force_os == :mac
      return default_linux if (chrome_version == unknown_chrome_version) || force_os == :linux

      chromedriver_path_for_version(chrome_version.segments.first)
    end

    private

    # @return [String] default mac chromedriver
    def default_mac
      "#{File.dirname(__FILE__)}/chromedriver_bin/chromedriver_mac"
    end

    # @return [String] default linux chromedriver, always use latest version
    def default_linux
      Dir["#{File.dirname(__FILE__)}/chromedriver_bin/chromedriver_linux_*"].max
    end

    # @param [String] major_version major version of chrome
    # @return [String] path to chromedriver of version
    def chromedriver_path_for_version(major_version)
      file_path = "#{File.dirname(__FILE__)}/chromedriver_bin/chromedriver_linux_#{major_version}"
      if File.exist?(file_path)
        OnlyofficeLoggerHelper.log("Chromedriver found by version #{major_version}. Using it")
        return file_path
      end

      OnlyofficeLoggerHelper.log("Cannot file chromedriver by version #{major_version}. Using Default")
      default_linux
    end
  end
end

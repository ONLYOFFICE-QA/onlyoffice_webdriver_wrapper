# frozen_string_literal: true

require_relative 'chrome_helper/chrome_version_helper'

module OnlyofficeWebdriverWrapper
  # Class for working with Chrome
  module ChromeHelper
    include ChromeVersionHelper

    # @return [String] list of default Chrome command line switches
    DEFAULT_CHROME_SWITCHES = %w[--kiosk-printing
                                 --disable-gpu
                                 --disable-popup-blocking
                                 --disable-infobars
                                 --no-sandbox
                                 test-type].freeze

    # @return [Selenium::WebDriver::Chrome::Service] Instance of Chrome Service object
    def chrome_service
      @chrome_service ||= Selenium::WebDriver::Chrome::Service.new(path: chromedriver_path)
    end

    # @return [Selenium::WebDriver::Chrome::Driver] Chrome webdriver
    def start_chrome_driver
      prefs = {
        download: {
          'prompt_for_download' => false,
          'default_directory' => download_directory
        },
        profile: {
          'default_content_setting_values' => {
            'automatic_downloads' => 1
          }
        },
        credentials_enable_service: false
      }
      switches = add_useragent_to_switches(DEFAULT_CHROME_SWITCHES)
      options = Selenium::WebDriver::Chrome::Options.new(args: switches,
                                                         prefs: prefs)
      webdriver_options = { options: options,
                            service: chrome_service }
      driver = ensure_chrome_started(webdriver_options)
      maximize_chrome(driver)
      driver
    end

    private

    # Ensure that chrome started
    # Retry it several times if some unexpected error happened
    # @param options [Selenium::WebDriver::Chrome::Options] options to use
    # @return [Selenium::WebDriver::Chrome::Driver] driver
    def ensure_chrome_started(options)
      retries = 3
      begin
        retries -= 1
        return Selenium::WebDriver.for :chrome, options
      rescue Selenium::WebDriver::Error::SessionNotCreatedError => e
        OnlyofficeLoggerHelper.log("Starting chrome failed with error: #{e.message}")
        if retries > 0
          sleep(rand(1..5)) # Random timeout to start
          retry
        else
          raise e
        end
      end
    end

    # Maximize chrome
    # @param driver [Selenium::WebDriver] driver to use
    # @return [Void]
    def maximize_chrome(driver)
      if headless.running?
        # Cannot use `driver.manage.window.maximize` in xvfb session
        # according to https://bugs.chromium.org/p/chromedriver/issues/detail?id=1901#c16
        driver.manage.window.size = Selenium::WebDriver::Dimension.new(headless.resolution_x, headless.resolution_y)
      else
        driver.manage.window.maximize
      end
    end
  end
end

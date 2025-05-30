# frozen_string_literal: true

require 'onlyoffice_file_helper'
require 'page-object'
require 'securerandom'
require 'selenium-webdriver'
require 'uri'
require_relative 'helpers/chrome_helper'
require_relative 'helpers/firefox_helper'
require_relative 'webdriver/click_methods'
require_relative 'webdriver/element_getters'
require_relative 'webdriver/get_text_methods'
require_relative 'webdriver/scroll_methods'
require_relative 'webdriver/select_list_methods'
require_relative 'webdriver/wait_until_methods'
require_relative 'webdriver/webdriver_alert_helper'
require_relative 'webdriver/webdriver_attributes_helper'
require_relative 'webdriver/webdriver_browser_info_helper'
require_relative 'webdriver/webdriver_type_helper'
require_relative 'webdriver/webdriver_exceptions'
require_relative 'webdriver/webdriver_frame_methods'
require_relative 'webdriver/webdriver_helper'
require_relative 'webdriver/webdriver_js_methods'
require_relative 'webdriver/webdriver_move_cursor_methods'
require_relative 'webdriver/webdriver_navigation_methods'
require_relative 'webdriver/webdriver_screenshot_helper'
require_relative 'webdriver/webdriver_style_helper'
require_relative 'webdriver/webdriver_tab_helper'
require_relative 'webdriver/webdriver_user_agent_helper'
require_relative 'webdriver/webdriver_browser_log_helper'

# Namespace of this gem
module OnlyofficeWebdriverWrapper
  # Class for working with webdriver, main class of project
  class WebDriver
    include ChromeHelper
    include ClickMethods
    include GetTextMethods
    include ScrollMethods
    include SelectListMethods
    include FirefoxHelper
    include RubyHelper
    include WaitUntilMethods
    include WebdriverAlertHelper
    include WebdriverAttributesHelper
    include WebdriverBrowserInfo
    include WebdriverTypeHelper
    include WebdriverFrameMethods
    include WebdriverHelper
    include WebdriverJsMethods
    include WebdriverMoveCursorMethods
    include WebdriverNavigationMethods
    include WebdriverScreenshotHelper
    include WebdriverStyleHelper
    include WebdriverTabHelper
    include WebdriverUserAgentHelper
    include WebdriverBrowserLogHelper
    # @return [Integer] Default timeout for waiting to file to download
    TIMEOUT_FILE_DOWNLOAD = 100
    # @return [Array<Symbol>] list of supported browsers
    SUPPORTED_BROWSERS = %i[firefox chrome].freeze
    # @return [Array, String] default switches for chrome
    attr_accessor :driver
    # @return [Symbol] browser to use
    attr_accessor :browser
    # @return [True, False] is browser currently running
    attr_reader :browser_running
    # @return [Symbol] device of which we try to simulate, default - :desktop_linux
    attr_accessor :device
    # @return [String] directory to which file is downloaded
    attr_accessor :download_directory
    # @return [HeadlessHelper] headless wrapper
    attr_accessor :headless
    # @return [True, False] should video be recorded
    attr_reader :record_video

    def initialize(browser = :firefox, params = {})
      raise WebdriverSystemNotSupported, 'Your OS is not 64 bit. It is not supported' unless os_64_bit?

      ensure_supported_browser(browser)
      @device = params.fetch(:device, :desktop_linux)
      @record_video = params.fetch(:record_video, true)
      @headless = HeadlessHelper.new(record_video: record_video)
      @headless.start

      @download_directory = params.fetch(:download_directory, Dir.mktmpdir('webdriver-download'))
      @browser = params.fetch(:browser, browser)
      return if params[:do_not_start_browser]

      case browser
      when :firefox
        @driver = start_firefox_driver
      when :chrome
        @driver = start_chrome_driver
      end
      @browser_running = true
    end

    # Ensure that browser is supported
    # @param [Symbol] browser to check
    # @raise [RuntimeError] if browser is not supported
    # @return [void]
    def ensure_supported_browser(browser)
      return if SUPPORTED_BROWSERS.include?(browser)

      raise("Unknown Browser: #{browser}")
    end

    # Open dropdown selector, like 'Color Selector', which has no element id
    # @param [String] xpath_name name of dropdown list
    # @param [Integer] horizontal_shift x value
    # @param [Integer] vertical_shift y value
    # @return [void]
    def open_dropdown_selector(xpath_name, horizontal_shift = 30, vertical_shift = 0)
      move_to_driver_action(xpath_name, horizontal_shift, vertical_shift).click.perform
    end

    # Perform an action on coordinate
    # @param [String] xpath_name to find element
    # @param [Integer] right_by x coordinate
    # @param [Integer] down_by y coordinate
    # @param [Symbol] action to perform
    # @param [Integer] times how much times to repeat
    # @return [void]
    def action_on_locator_coordinates(xpath_name, right_by, down_by, action = :click, times = 1)
      wait_until_element_visible(xpath_name)
      (0...times).inject(move_to_driver_action(xpath_name, right_by, down_by)) { |acc, _elem| acc.send(action) }.perform
    end

    # Check if element present on page
    # It may be visible or invisible, but should be present in DOM tree
    # @param [String] xpath_name to find element
    # @return [Boolean] result of check
    def element_present?(xpath_name)
      case xpath_name
      when PageObject::Elements::Element
        xpath_name.present?
      when Selenium::WebDriver::Element
        xpath_name.displayed?
      else
        @driver.find_element(:xpath, xpath_name)
        true
      end
    rescue StandardError
      false
    end

    # Return count of elements (visible and not visible)
    # @param xpath_name [String] xpath to find
    # @param only_visible [True, False] count only visible elements?
    # @return [Integer] element count
    def get_element_count(xpath_name, only_visible = true)
      if element_present?(xpath_name)
        elements = @driver.find_elements(:xpath, xpath_name)
        only_visible ? elements.delete_if { |element| !element.displayed? }.length : elements.length
      else
        0
      end
    end

    # Check if element visible on page
    # It should be part of DOM and should be visible on current visible part of page
    # @param [String] xpath_name element to find
    # @return [Boolean] result of check
    def element_visible?(xpath_name)
      if xpath_name.is_a?(PageObject::Elements::Element) # PageObject always visible
        true
      elsif element_present?(xpath_name)
        element = get_element(xpath_name)
        return false if element.nil?

        begin
          visible = element.displayed?
        rescue StandardError => e
          OnlyofficeLoggerHelper.log("Element #{xpath_name} is not visible because of: #{e.message}")
          visible = false
        end
        visible
      else
        false
      end
    end

    # Check if any element of xpath is displayed
    # @param xpath_several_elements [String] xpath to check
    # @return [True, False] result of visibility
    def one_of_several_elements_displayed?(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        return true if current_element.displayed?
      end
      false
    rescue StandardError => e
      webdriver_error("Raise unknown exception: #{e}")
    end

    # Get page source
    # @return [String] all page source
    def page_source
      @driver.execute_script('return document.documentElement.innerHTML;')
    end

    alias get_page_source page_source

    extend Gem::Deprecate
    deprecate :get_page_source, 'page_source', 2069, 1

    # Raise an error, making a screenshot before it
    # @param [String, Object] exception class to raise
    # @param [String] error_message to raise
    # @raise [Object] specified exception
    # @return [void]
    def webdriver_error(exception, error_message = nil)
      if exception.is_a?(String) # If there is no error_message
        error_message = exception
        exception = RuntimeError
      end
      select_top_frame
      raise exception, "#{error_message}\n\nPage address: #{current_url}\n\nError #{webdriver_screenshot}"
    end

    # Wait for file to be downloaded
    # @param [String] file_name to wait for download
    # @param [Integer] timeout to wait for file to download
    # @raise [StandardError] error if something happened and file not downloaded
    # @return [String] full file name of downloaded file
    def wait_file_for_download(file_name, timeout = TIMEOUT_FILE_DOWNLOAD)
      full_file_name = "#{@download_directory}/#{file_name}"
      full_file_name = file_name if file_name[0] == '/'
      counter = 0
      while !File.exist?(full_file_name) && counter < timeout
        OnlyofficeLoggerHelper.log("Waiting for download file #{full_file_name} for #{counter} of #{timeout}")
        sleep 1
        counter += 1
      end
      webdriver_error("File #{full_file_name} not download for #{timeout} seconds") if counter >= timeout
      full_file_name
    end

    # Perform cleanup if something went wrong during tests
    # @param forced [True, False] should cleanup run in all cases
    def self.clean_up(forced = false)
      return unless OnlyofficeFileHelper::LinuxHelper.user_name.include?('nct-at') ||
                    OnlyofficeFileHelper::LinuxHelper.user_name.include?('ubuntu') ||
                    forced

      OnlyofficeFileHelper::LinuxHelper.kill_all('chromedriver')
      OnlyofficeFileHelper::LinuxHelper.kill_all('geckodriver')
      OnlyofficeFileHelper::LinuxHelper.kill_all('Xvfb')
      OnlyofficeFileHelper::LinuxHelper.kill_all_browsers
    end
  end
end

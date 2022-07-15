# frozen_string_literal: true

require 'onlyoffice_file_helper'
require 'page-object'
require 'securerandom'
require 'selenium-webdriver'
require 'uri'
require_relative 'helpers/chrome_helper'
require_relative 'helpers/firefox_helper'
require_relative 'webdriver/click_methods'
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
  # noinspection RubyTooManyMethodsInspection, RubyInstanceMethodNamingConvention, RubyParameterNamingConvention
  class WebDriver
    include ChromeHelper
    include ClickMethods
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
    # @return [Net::HTTP::Proxy] connection proxy
    attr_accessor :proxy
    # @return [True, False] should video be recorded
    attr_reader :record_video

    def initialize(browser = :firefox, params = {})
      raise WebdriverSystemNotSupported, 'Your OS is not 64 bit. It is not supported' unless os_64_bit?

      @device = params.fetch(:device, :desktop_linux)
      @record_video = params.fetch(:record_video, true)
      @headless = HeadlessHelper.new(record_video: record_video)
      @headless.start

      @download_directory = params.fetch(:download_directory, Dir.mktmpdir('webdriver-download'))
      @browser = params.fetch(:browser, browser)
      @proxy = params[:proxy]
      return if params[:do_not_start_browser]

      case browser
      when :firefox
        @driver = start_firefox_driver
      when :chrome
        @driver = start_chrome_driver
      else
        raise("Unknown Browser: #{browser}")
      end
      @browser_running = true
    end

    # Get element by it's xpath
    # @param [String] object_identification xpath of object to find
    # @return [Object, nil] nil if nothing found
    def get_element(object_identification)
      return object_identification unless object_identification.is_a?(String)

      @driver.find_element(:xpath, object_identification)
    rescue StandardError
      nil
    end

    # Get text from all elements with specified xpath
    # @param array_elements [String] xpath of elements
    # @return [Array<String>] values of elements
    def get_text_array(array_elements)
      get_elements(array_elements).map { |current_element| get_text(current_element) }
    end

    # Scroll list to specific element
    # @param [String] list_xpath how to find this list
    # @param [String] element_xpath to which we should scrolled
    # @return [void]
    def scroll_list_to_element(list_xpath, element_xpath)
      execute_javascript("$(document.evaluate(\"#{list_xpath}\", document, null, XPathResult.ANY_TYPE, null).
          iterateNext()).jScrollPane().data('jsp').scrollToElement(document.evaluate(\"#{element_xpath}\",
          document, null, XPathResult.ANY_TYPE, null).iterateNext());")
    end

    # Scroll list by pixel count
    # @param [String] list_xpath how to detect this list
    # @param [Integer] pixels how much to scroll
    # @return [void]
    def scroll_list_by_pixels(list_xpath, pixels)
      execute_javascript("$(document.evaluate(\"#{list_xpath.tr('"', "'")}\", document, null, XPathResult.ANY_TYPE, null).iterateNext()).scrollTop(#{pixels})")
    end

    # Open dropdown selector, like 'Color Selector', which has no element id
    # @param [String] xpath_name name of dropdown list
    # @param [Integer] horizontal_shift x value
    # @param [Integer] vertical_shift y value
    # @return [void]
    def open_dropdown_selector(xpath_name, horizontal_shift = 30, vertical_shift = 0)
      element = get_element(xpath_name)
      if @browser == :firefox || @browser == :safari
        set_style_attribute("#{xpath_name}/button", 'display', 'none')
        set_style_attribute(xpath_name, 'display', 'inline')
        element.click
        set_style_attribute("#{xpath_name}/button", 'display', 'inline-block')
        set_style_attribute(xpath_name, 'display', 'block')
      else
        move_to_driver_action(xpath_name, horizontal_shift, vertical_shift).click.perform
      end
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
    rescue Exception
      false
    end

    # Get first visible element from several
    # @param [String] xpath_name to find several objects
    # @return [Object] first visible element
    def get_element_by_display(xpath_name)
      @driver.find_elements(:xpath, xpath_name).each do |element|
        return element if element.displayed?
      end
    rescue Selenium::WebDriver::Error::InvalidSelectorError
      webdriver_error("get_element_by_display(#{xpath_name}): invalid selector: Unable to locate an element with the xpath expression")
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

    # Get array of webdriver object by xpath
    # @param [String] objects_identification object to find
    # @param [Boolean] only_visible return invisible if true
    # @return [Array, Object] list of objects
    def get_elements(objects_identification, only_visible = true)
      return objects_identification if objects_identification.is_a?(Array)

      elements = @driver.find_elements(:xpath, objects_identification)
      if only_visible
        elements.each do |current|
          elements.delete(current) unless @browser == :firefox || current.displayed?
        end
      end
      elements
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
        rescue Exception => e
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
    rescue Exception => e
      webdriver_error("Raise unknown exception: #{e}")
    end

    # Get text of current element
    # @param [String] xpath_name name of xpath
    # @param [Boolean] wait_until_visible wait until element visible
    # @return [String] result string
    def get_text(xpath_name, wait_until_visible = true)
      wait_until_element_visible(xpath_name) if wait_until_visible

      element = get_element(xpath_name)
      webdriver_error("get_text(#{xpath_name}, #{wait_until_visible}) not found element by xpath") if element.nil?
      if element.tag_name == 'input' || element.tag_name == 'textarea'
        element.attribute('value')
      else
        element.text
      end
    end

    # Get text from several elements
    # @param [String] xpath_several_elements to find objects
    # @return [Array<String>] text of those elements
    def get_text_of_several_elements(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).filter_map { |element| element.text unless element.text == '' }
    end

    # Get page source
    # @return [String] all page source
    def get_page_source
      @driver.execute_script('return document.documentElement.innerHTML;')
    end

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
      current_url = get_url
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

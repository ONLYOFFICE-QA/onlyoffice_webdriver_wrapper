# frozen_string_literal: true

require 'onlyoffice_file_helper'
require 'page-object'
require 'securerandom'
require 'selenium-webdriver'
require 'uri'
require_relative 'helpers/chrome_helper'
require_relative 'helpers/firefox_helper'
require_relative 'webdriver/click_methods'
require_relative 'webdriver/wait_until_methods'
require_relative 'webdriver/webdriver_alert_helper'
require_relative 'webdriver/webdriver_attributes_helper'
require_relative 'webdriver/webdriver_browser_info_helper'
require_relative 'webdriver/webdriver_type_helper'
require_relative 'webdriver/webdriver_exceptions'
require_relative 'webdriver/webdriver_helper'
require_relative 'webdriver/webdriver_js_methods'
require_relative 'webdriver/webdriver_screenshot_helper'
require_relative 'webdriver/webdriver_style_helper'
require_relative 'webdriver/webdriver_tab_helper'
require_relative 'webdriver/webdriver_user_agent_helper'
require_relative 'webdriver/webdriver_browser_log_helper'

module OnlyofficeWebdriverWrapper
  # noinspection RubyTooManyMethodsInspection, RubyInstanceMethodNamingConvention, RubyParameterNamingConvention
  class WebDriver
    include ChromeHelper
    include ClickMethods
    include FirefoxHelper
    include RubyHelper
    include WaitUntilMethods
    include WebdriverAlertHelper
    include WebdriverAttributesHelper
    include WebdriverBrowserInfo
    include WebdriverTypeHelper
    include WebdriverHelper
    include WebdriverJsMethods
    include WebdriverScreenshotHelper
    include WebdriverStyleHelper
    include WebdriverTabHelper
    include WebdriverUserAgentHelper
    include WebdriverBrowserLogHelper
    TIMEOUT_FILE_DOWNLOAD = 100
    # @return [Array, String] default switches for chrome
    attr_accessor :driver
    attr_accessor :browser
    # @return [True, False] is browser currently running
    attr_reader :browser_running
    # @return [Symbol] device of which we try to simulate, default - :desktop_linux
    attr_accessor :device
    attr_accessor :download_directory
    attr_accessor :server_address
    attr_accessor :headless
    # @return [Net::HTTP::Proxy] connection proxy
    attr_accessor :proxy

    def initialize(browser = :firefox,
                   _remote_server = nil,
                   device: :desktop_linux,
                   proxy: nil)
      raise WebdriverSystemNotSupported, 'Your OS is not 64 bit. It is not supported' unless os_64_bit?

      @device = device
      @headless = HeadlessHelper.new
      @headless.start

      @download_directory = Dir.mktmpdir('webdriver-download')
      @browser = browser
      @proxy = proxy
      case browser
      when :firefox
        @driver = start_firefox_driver
      when :chrome
        @driver = start_chrome_driver
      else
        raise 'Unknown Browser: ' + browser.to_s
      end
      @browser_running = true
    end

    def open(url)
      url = 'http://' + url unless url.include?('http') || url.include?('file://')
      loop do
        begin
          @driver.navigate.to url
          break
        rescue Timeout::Error
          @driver.navigate.refresh
        end
      end
      OnlyofficeLoggerHelper.log("Opened page: #{url}")
    end

    def quit
      return unless browser_running

      begin
        @driver.execute_script('window.onbeforeunload = null') # off popup window
      rescue StandardError
        Exception
      end
      begin
        @driver.quit
      rescue Exception => e
        OnlyofficeLoggerHelper.log("Some error happened on webdriver.quit #{e.backtrace}")
      end
      alert_confirm
      @headless.stop
      cleanup_download_folder
      @browser_running = false
    end

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

    def select_from_list_elements(value, elements_value)
      index = get_element_index(value, elements_value)
      elements_value[index].click
    end

    def get_element_index(title, list_elements)
      list_elements.each_with_index do |current, i|
        return i if get_text(current) == title
      end
      nil
    end

    def get_all_combo_box_values(xpath_name)
      @driver.find_element(:xpath, xpath_name).find_elements(tag_name: 'option').map { |el| el.attribute('value') }
    end

    # @return [String] url of current frame, or browser url if
    # it is a root frame
    def get_url
      execute_javascript('return window.location.href')
    rescue Selenium::WebDriver::Error::NoSuchDriverError
      raise 'Browser is crushed or hangup'
    end

    def refresh
      @driver.navigate.refresh
      OnlyofficeLoggerHelper.log('Refresh page')
    end

    def go_back
      @driver.navigate.back
      OnlyofficeLoggerHelper.log('Go back to previous page')
    end

    # Perform drag'n'drop action in one element (for example on big canvas area)
    # for drag'n'drop one whole element use 'drag_and_drop_by'
    # ==== Attributes
    #
    # * +xpath+ - xpath of element on which drag and drop performed
    # * +x1+ - x coordinate on element to start drag'n'drop
    # * +y1+ - y coordinate on element to start drag'n'drop
    # * +x2+ - shift vector x coordinate
    # * +y2+ - shift vector y coordinate
    # * +mouse_release+ - release mouse after move
    def drag_and_drop(xpath, x1, y1, x2, y2, mouse_release: true)
      canvas = get_element(xpath)

      move_action = @driver.action
                           .move_to(canvas, x1.to_i, y1.to_i)
                           .click_and_hold
                           .move_by(x2, y2)
      move_action = move_action.release if mouse_release

      move_action.perform
    end

    # Perform drag'n'drop one whole element
    # for drag'n'drop inside one element (f.e. canvas) use drag_and_drop
    # ==== Attributes
    #
    # * +source+ - xpath of element on which drag and drop performed
    # * +right_by+ - shift vector x coordinate
    # * +down_by+ - shift vector y coordinate
    def drag_and_drop_by(source, right_by, down_by = 0)
      @driver.action.drag_and_drop_by(get_element(source), right_by, down_by).perform
    end

    def scroll_list_to_element(list_xpath, element_xpath)
      execute_javascript("$(document.evaluate(\"#{list_xpath}\", document, null, XPathResult.ANY_TYPE, null).
          iterateNext()).jScrollPane().data('jsp').scrollToElement(document.evaluate(\"#{element_xpath}\",
          document, null, XPathResult.ANY_TYPE, null).iterateNext());")
    end

    def scroll_list_by_pixels(list_xpath, pixels)
      execute_javascript("$(document.evaluate(\"#{list_xpath.tr('"', "'")}\", document, null, XPathResult.ANY_TYPE, null).iterateNext()).scrollTop(#{pixels})")
    end

    # Open dropdown selector, like 'Color Selector', which has no element id
    # @param [String] xpath_name name of dropdown list
    def open_dropdown_selector(xpath_name, horizontal_shift = 30, vertical_shift = 0)
      element = get_element(xpath_name)
      if @browser == :firefox || @browser == :safari
        set_style_attribute(xpath_name + '/button', 'display', 'none')
        set_style_attribute(xpath_name, 'display', 'inline')
        element.click
        set_style_attribute(xpath_name + '/button', 'display', 'inline-block')
        set_style_attribute(xpath_name, 'display', 'block')
      else
        @driver.action.move_to(element, horizontal_shift, vertical_shift).click.perform
      end
    end

    def action_on_locator_coordinates(xpath_name, right_by, down_by, action = :click, times = 1)
      wait_until_element_visible(xpath_name)
      element = @driver.find_element(:xpath, xpath_name)
      (0...times).inject(@driver.action.move_to(element, right_by.to_i, down_by.to_i)) { |acc, _elem| acc.send(action) }.perform
    end

    def move_to_element(element)
      element = get_element(element) if element.is_a?(String)
      @driver.action.move_to(element).perform
    end

    def move_to_element_by_locator(xpath_name)
      element = get_element(xpath_name)
      @driver.action.move_to(element).perform
      OnlyofficeLoggerHelper.log("Moved mouse to element: #{xpath_name}")
    end

    def mouse_over(xpath_name, x_coordinate = 0, y_coordinate = 0)
      wait_until_element_present(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name), x_coordinate.to_i, y_coordinate.to_i).perform
    end

    def element_present?(xpath_name)
      if xpath_name.is_a?(PageObject::Elements::Element)
        xpath_name.present?
      elsif xpath_name.is_a?(Selenium::WebDriver::Element)
        xpath_name.displayed?
      else
        @driver.find_element(:xpath, xpath_name)
        true
      end
    rescue Exception
      false
    end

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

    def element_visible?(xpath_name)
      if xpath_name.is_a?(PageObject::Elements::Element) # PageObject always visible
        true
      elsif element_present?(xpath_name)
        element = get_element(xpath_name)
        return false if element.nil?

        begin
          visible = element.displayed?
        rescue Exception
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
      webdriver_error("Raise unkwnown exception: #{e}")
    end

    def wait_element(xpath_name, period_of_wait = 1, critical_time = 3)
      wait_until_element_present(xpath_name)
      time = 0
      until element_visible?(xpath_name)
        sleep(period_of_wait)
        time += 1
        return if time == critical_time
      end
    end

    # Select frame as current
    # @param [String] xpath_name name of current xpath
    def select_frame(xpath_name = '//iframe', count_of_frames = 1)
      (0...count_of_frames).each do
        begin
          frame = @driver.find_element(:xpath, xpath_name)
          @driver.switch_to.frame frame
        rescue Selenium::WebDriver::Error::NoSuchElementError
          OnlyofficeLoggerHelper.log('Raise NoSuchElementError in the select_frame method')
        rescue Exception => e
          webdriver_error("Raise unkwnown exception: #{e}")
        end
      end
    end

    # Select top frame of browser (even if several subframes exists)
    def select_top_frame
      @driver.switch_to.default_content
    rescue Timeout::Error
      OnlyofficeLoggerHelper.log('Raise TimeoutError in the select_top_frame method')
    rescue Exception => e
      raise "Browser is crushed or hangup with error: #{e}"
    end

    # Get text of current element
    # @param [String] xpath_name name of xpath
    # @param [true, false] wait_until_visible wait until element visible [@default = true]
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

    def get_text_of_several_elements(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).map { |element| element.text unless element.text == '' }.compact
    end

    def set_parameter(xpath, attribute, attribute_value)
      execute_javascript("document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext()." \
                             "#{attribute}=\"#{attribute_value}\";")
    end

    def remove_attribute(xpath, attribute)
      execute_javascript("document.evaluate(\"#{xpath}\",document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)." \
                             "singleNodeValue.removeAttribute('#{attribute}');")
    end

    def select_combo_box(xpath_name, select_value, select_by = :value)
      wait_until_element_visible(xpath_name)
      option = Selenium::WebDriver::Support::Select.new(get_element(xpath_name))
      begin
        option.select_by(select_by, select_value)
      rescue StandardError
        option.select_by(:text, select_value)
      end
    end

    # Get page source
    # @return [String] all page source
    def get_page_source
      @driver.execute_script('return document.documentElement.innerHTML;')
    end

    def webdriver_error(exception, error_message = nil)
      if exception.is_a?(String) # If there is no error_message
        error_message = exception
        exception = RuntimeError
      end
      select_top_frame
      current_url = get_url
      raise exception, "#{error_message}\n\nPage address: #{current_url}\n\nError #{webdriver_screenshot}"
    end

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
                    forced == true

      OnlyofficeFileHelper::LinuxHelper.kill_all('chromedriver')
      OnlyofficeFileHelper::LinuxHelper.kill_all('geckodriver')
      OnlyofficeFileHelper::LinuxHelper.kill_all('Xvfb')
      OnlyofficeFileHelper::LinuxHelper.kill_all_browsers
    end
  end
end

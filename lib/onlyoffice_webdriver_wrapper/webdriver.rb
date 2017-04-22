require 'page-object'
require 'securerandom'
require 'selenium-webdriver'
require 'uri'
require_relative 'helpers/chrome_helper'
require_relative 'helpers/firefox_helper'
require_relative 'helpers/file_helper'
require_relative 'webdriver/webdriver_alert_helper'
require_relative 'webdriver/webdriver_attributes_helper'
require_relative 'webdriver/webdriver_type_helper'
require_relative 'webdriver/webdriver_exceptions'
require_relative 'webdriver/webdriver_extension'
require_relative 'webdriver/webdriver_helper'
require_relative 'webdriver/webdriver_js_methods'
require_relative 'webdriver/webdriver_screenshot_helper'
require_relative 'webdriver/webdriver_style_helper'
require_relative 'webdriver/webdriver_tab_helper'
require_relative 'webdriver/webdriver_user_agent_helper'

module OnlyofficeWebdriverWrapper
  # noinspection RubyTooManyMethodsInspection, RubyInstanceMethodNamingConvention, RubyParameterNamingConvention
  class WebDriver
    include ChromeHelper
    include FirefoxHelper
    include RubyHelper
    include WebdriverAlertHelper
    include WebdriverAttributesHelper
    include WebdriverTypeHelper
    include WebdriverHelper
    include WebdriverJsMethods
    include WebdriverScreenshotHelper
    include WebdriverStyleHelper
    include WebdriverTabHelper
    include WebdriverUserAgentHelper
    TIMEOUT_WAIT_ELEMENT = 15
    TIMEOUT_FILE_DOWNLOAD = 100
    # @return [Array, String] default switches for chrome
    attr_accessor :driver
    attr_accessor :browser
    # @return [Symbol] device of which we try to simulate, default - :desktop_linux
    attr_accessor :device
    attr_accessor :ip_of_remote_server
    attr_accessor :download_directory
    attr_accessor :server_address
    attr_accessor :headless

    singleton_class.class_eval { attr_accessor :web_console_error }

    def initialize(browser = :firefox, remote_server = nil, device: :desktop_linux)
      raise WebdriverSystemNotSupported, 'Your OS is not 64 bit. It is not supported' unless os_64_bit?
      @device = device
      @headless = HeadlessHelper.new
      @headless.start

      @download_directory = Dir.mktmpdir('webdriver-download')
      @browser = browser
      @ip_of_remote_server = remote_server
      case browser
      when :firefox
        @driver = start_firefox_driver
      when :chrome
        @driver = start_chrome_driver
      else
        raise 'Unknown Browser: ' + browser.to_s
      end
    end

    def browser_size
      size_struct = @driver.manage.window.size
      size = Dimensions.new(size_struct.width, size_struct.height)
      OnlyofficeLoggerHelper.log("browser_size: #{size}")
      size
    end

    def add_web_console_error(log)
      WebDriver.web_console_error = log
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
      begin
        @driver.execute_script('window.onbeforeunload = null')
      rescue
        Exception
      end # OFF POPUP WINDOW
      begin
        @driver.quit
      rescue Exception => e
        OnlyofficeLoggerHelper.log("Some error happened on webdriver.quit #{e.backtrace}")
      end
      alert_confirm
      @headless.stop
    end

    def get_element(object_identification)
      return object_identification unless object_identification.is_a?(String)
      @driver.find_element(:xpath, object_identification)
    rescue
      nil
    end

    def set_text_to_iframe(element, text)
      element.click
      @driver.action.send_keys(text).perform
    end

    def get_text_array(array_elements)
      get_elements(array_elements).map { |current_element| get_text(current_element) }
    end

    def click(element)
      element.click
    end

    def secure_click(element)
      wait_until { element.present? }
      element.click
    end

    def click_and_wait(element_to_click, element_to_wait)
      element_to_click.click
      count = 0
      while !element_to_wait.visible? && count < 30
        sleep 1
        count += 1
      end
      webdriver_error("click_and_wait: Wait for element: #{element_to_click} for 30 seconds") if count == 30
    end

    def execute_javascript(script)
      @driver.execute_script(script)
    rescue Exception => e
      webdriver_error("Exception #{e} in execute_javascript: #{script}")
    end

    def select_from_list(xpath_value, value)
      @driver.find_element(:xpath, xpath_value).find_elements(tag_name: 'li').each do |element|
        next unless element.text == value.to_s
        element.click
        return true
      end

      webdriver_error("select_from_list: Option #{value} in list #{xpath_value} not found")
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

    def self.host_name_by_full_url(full_url)
      uri = URI(full_url)
      uri.port == 80 || uri.port == 443 ? "#{uri.scheme}://#{uri.host}" : "#{uri.scheme}://#{uri.host}:#{uri.port}"
    end

    def get_host_name
      WebDriver.host_name_by_full_url(get_url)
    end

    def remove_event(event_name)
      execute_javascript("jQuery(document).unbind('#{event_name}');")
    end

    def remove_class_by_jquery(selector, class_name)
      execute_javascript('cd(window.frames[0])')
      execute_javascript("$('#{selector}').removeClass('#{class_name}');")
    end

    def add_class_by_jquery(selector, class_name)
      execute_javascript("$('#{selector}').addClass('#{class_name}');")
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
      if mouse_release
        @driver.action.move_to(canvas, x1, y1).click_and_hold.move_by(x2, y2).release.perform
      else
        @driver.action.move_to(canvas, x1, y1).click_and_hold.move_by(x2, y2).perform
      end
    rescue ArgumentError
      raise "Replace 'click_and_hold(element)' to 'click_and_hold(element = nil)' in action_builder.rb"
    rescue TypeError => e
      webdriver_error("drag_and_drop(#{xpath}, #{x1}, #{y1}, #{x2}, #{y2}) TypeError: #{e.message}")
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

    # Click on locator
    def click_on_locator(xpath_name, by_javascript = false)
      element = get_element(xpath_name)
      return webdriver_error("Element with xpath: #{xpath_name} not found") if element.nil?
      if by_javascript
        execute_javascript("document.evaluate(\"#{xpath_name}\", document, null, XPathResult.ANY_TYPE, null).iterateNext().click();")
      else
        begin
          element.click
        rescue Selenium::WebDriver::Error::ElementNotVisibleError
          webdriver_error("Selenium::WebDriver::Error::ElementNotVisibleError: element not visible for xpath: #{xpath_name}")
        rescue Exception => e
          webdriver_error(e.class, "UnknownError #{e.message} #{xpath_name}")
        end
      end
    end

    def left_mouse_click(xpath, x_coord, y_coord)
      @driver.action.move_to(get_element(xpath), x_coord, y_coord).click.perform
    end

    # Context click on locator
    # @param [String] xpath_name name of xpath to click
    def context_click_on_locator(xpath_name)
      wait_until_element_visible(xpath_name)

      element = @driver.find_element(:xpath, xpath_name)
      @driver.action.context_click(element).perform
    end

    def right_click(xpath_name)
      @driver.mouse.context_click(@driver.find_element(:xpath, xpath_name))
    end

    def context_click(xpath, x_coord, y_coord)
      element = get_element(xpath)
      if browser == :firefox
        element.send_keys %i(shift f10)
      else
        @driver.action.move_to(element, x_coord, y_coord).context_click.perform
      end
    end

    def click_on_displayed(xpath_name)
      element = get_element_by_display(xpath_name)
      begin
        element.is_a?(Array) ? element.first.click : element.click
      rescue Exception => e
        webdriver_error("Exception #{e} in click_on_displayed(#{xpath_name})")
      end
    end

    def click_on_locator_by_action(xpath)
      @driver.action.move_to(get_element(xpath)).click.perform
    end

    def click_on_locator_coordinates(xpath_name, right_by, down_by)
      wait_until_element_visible(xpath_name)
      element = @driver.find_element(:xpath, xpath_name)
      @driver.action.move_to(element, right_by, down_by).perform
      @driver.action.move_to(element, right_by, down_by).click.perform
    end

    def right_click_on_locator_coordinates(xpath_name, right_by = nil, down_by = nil)
      wait_until_element_visible(xpath_name)
      element = @driver.find_element(:xpath, xpath_name)
      @driver.action.move_to(element, right_by, down_by).perform
      @driver.action.move_to(element, right_by, down_by).context_click.perform
    end

    def double_click(xpath_name)
      wait_until_element_visible(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name)).double_click.perform
    end

    def double_click_on_locator_coordinates(xpath_name, right_by, down_by)
      wait_until_element_visible(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name), right_by, down_by).double_click.perform
    end

    def action_on_locator_coordinates(xpath_name, right_by, down_by, action = :click, times = 1)
      wait_until_element_visible(xpath_name)
      element = @driver.find_element(:xpath, xpath_name)
      (0...times).inject(@driver.action.move_to(element, right_by, down_by)) { |acc, _elem| acc.send(action) }.perform
    end

    def click_on_one_of_several_by_text(xpath_several_elements, text_to_click)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        next unless text_to_click.to_s == current_element.attribute('innerHTML')
        begin
          current_element.click
        rescue Exception => e
          webdriver_error("Error in click_on_one_of_several_by_text(#{xpath_several_elements}, #{text_to_click}): #{e.message}")
        end
        return true
      end
      false
    end

    def click_on_one_of_several_by_display(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if current_element.displayed?
          current_element.click
          return true
        end
      end
      false
    end

    def click_on_one_of_several_with_display_by_text(xpath_several_elements, text_to_click)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if current_element.displayed? && text_to_click == current_element.text
          current_element.click
          return true
        end
      end
      false
    end

    def right_click_on_one_of_several_by_text(xpath_several_elements, text_to_click)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if text_to_click == current_element.text
          @driver.mouse.context_click(current_element)
          return true
        end
      end
      false
    end

    def click_on_one_of_several_with_display_by_number(xpath_several_elements, number)
      @driver.find_elements(:xpath, "#{xpath_several_elements}[#{number}]").each do |current_element|
        if current_element.displayed?
          current_element.click
          return true
        end
      end
      false
    end

    def click_on_one_of_several_by_parameter(xpath_several_elements, parameter_name, parameter_value)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if current_element.attribute(parameter_name).include? parameter_value
          current_element.click
          return true
        end
      end
      false
    end

    def click_on_one_of_several_by_parameter_and_text(xpath_several_elements, parameter_name, parameter_value, text_to_click)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if current_element.attribute(parameter_name).include?(parameter_value) && text_to_click == current_element.text
          current_element.click
          return true
        end
      end
      false
    end

    def click_on_one_of_several_xpath_by_number(xpath, number_of_element)
      click_on_locator("(#{xpath})[#{number_of_element}]")
    end

    def move_to_element(element)
      element = get_element(element) if element.is_a?(String)
      @driver.action.move_to(element).perform
    end

    def move_to_element_by_locator(xpath_name)
      element = get_element(xpath_name)
      @driver.mouse.move_to(element)
      OnlyofficeLoggerHelper.log("Moved mouse to element: #{xpath_name}")
    end

    def move_to_one_of_several_displayed_element(xpath_several_elements)
      get_elements(xpath_several_elements).each do |current_element|
        if current_element.displayed?
          move_to_element(current_element)
          return true
        end
      end
      false
    end

    def mouse_over(xpath_name, x_coordinate = 0, y_coordinate = 0)
      wait_until_element_present(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name), x_coordinate, y_coordinate).perform
    end

    def element_present?(xpath_name)
      if xpath_name.is_a?(PageObject::Elements::Element)
        xpath_name.visible?
      elsif xpath_name.is_a?(Selenium::WebDriver::Element)
        xpath_name.displayed?
      else
        @driver.find_element(:xpath, xpath_name)
        true
      end
    rescue Exception
      false
    end

    def wait_until_element_present(xpath_name)
      wait = Selenium::WebDriver::Wait.new(timeout: TIMEOUT_WAIT_ELEMENT) # seconds
      begin
        wait.until { get_element(xpath_name) }
      rescue Selenium::WebDriver::Error::TimeOutError
        webdriver_error("wait_until_element_present(#{xpath_name}) Selenium::WebDriver::Error::TimeOutError: timed out after 15 seconds")
      end
    end

    def wait_until_element_disappear(xpath_name)
      wait = Selenium::WebDriver::Wait.new(timeout: TIMEOUT_WAIT_ELEMENT) # seconds
      begin
        wait.until { get_element(xpath_name) ? false : true }
      rescue Selenium::WebDriver::Error::TimeOutError
        webdriver_error("wait_until_element_present(#{xpath_name}) Selenium::WebDriver::Error::TimeOutError: timed out after 15 seconds")
      end
    end

    def get_elements_from_array_before_some(xpath_several_elements, xpath_for_some)
      elements = get_elements(xpath_several_elements)
      result = []
      some_element = get_element(xpath_for_some)
      return result if some_element.nil?
      elements.each do |current|
        break if current == some_element
        result << current
      end
      result
    end

    def get_elements_from_array_after_some(xpath_several_elements, xpath_for_some)
      elements = get_elements(xpath_several_elements)
      some_element = get_element(xpath_for_some)
      return elements if some_element.nil?
      elements.each do |current|
        elements.delete(current)
        break if current == some_element
      end
      elements
    end

    def get_element_by_display(xpath_name)
      @driver.find_elements(:xpath, xpath_name).each do |element|
        return element if element.displayed?
      end
    rescue Selenium::WebDriver::Error::InvalidSelectorError
      webdriver_error("get_element_by_display(#{xpath_name}): invalid selector: Unable to locate an element with the xpath expression")
    end

    def get_element_count(xpath_name, only_visible = true)
      if element_present?(xpath_name)
        elements = @driver.find_elements(:xpath, xpath_name)
        only_visible ? elements.delete_if { |element| @browser == :firefox && !element.displayed? }.length : elements.length
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

    def wait_until_element_visible(xpath_name, timeout = 15)
      wait_until_element_present(xpath_name)
      time = 0
      while !element_visible?(xpath_name) && time < timeout
        sleep(1)
        time += 1
      end
      return unless time >= timeout
      webdriver_error("Element #{xpath_name} not visible for #{timeout} seconds")
    end

    def one_of_several_elements_displayed?(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        return true if current_element.displayed?
      end
      false
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

    def remove_element(xpath)
      execute_javascript("element = document.evaluate(\"#{xpath}\", document, null, XPathResult.ANY_TYPE, null).iterateNext();if (element !== null) {element.parentNode.removeChild(element);};")
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

    def select_text_from_page(xpath_name)
      wait_until_element_visible(xpath_name)
      elem = get_element xpath_name
      @driver.action.key_down(:control).click(elem).send_keys('a').key_up(:control).perform
    end

    def select_combo_box(xpath_name, select_value, select_by = :value)
      wait_until_element_visible(xpath_name)
      option = Selenium::WebDriver::Support::Select.new(get_element(xpath_name))
      begin
        option.select_by(select_by, select_value)
      rescue
        option.select_by(:text, select_value)
      end
    end

    def get_element_number_by_text(xpath_list, element_text)
      @driver.find_elements(:xpath, xpath_list).each_with_index do |current_element, index|
        return index if element_text == current_element.attribute('innerHTML')
      end
      nil
    end

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

    def wait_until(timeout = ::PageObject.default_page_wait, message = nil, &block)
      tries ||= 3
      wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: message)
      wait.until(&block)
      wait.until { execute_javascript('return document.readyState;') == 'complete' }
      wait.until { jquery_finished? }
    rescue Selenium::WebDriver::Error::TimeOutError
      webdriver_error("Wait until timeout: #{timeout} seconds in")
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      OnlyofficeLoggerHelper.log("Wait until: rescuing from Stale Element error, #{tries} attempts remaining")
      retry unless (tries -= 1).zero?
      webdriver_error('Wait until: rescuing from Stale Element error failed after 3 tries')
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
      if counter >= timeout
        webdriver_error("File #{full_file_name} not download for #{timeout} seconds")
      end
      full_file_name
    end

    def service_unavailable?
      source = get_page_source
      source.include?('Error 503')
    end
  end
end

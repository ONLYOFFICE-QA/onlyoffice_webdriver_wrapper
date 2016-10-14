# encoding: utf-8
# noinspection SpellCheckingInspection
require 'selenium-webdriver'
require 'htmlentities'
require 'uri'
require_relative 'headless_helper'
require_relative 'file_helper'
require_relative 'webdriver/webdriver_helper'
require_relative 'webdriver/webdriver_js_methods'
require_relative 'webdriver/webdriver_user_agent_helper'

# noinspection RubyTooManyMethodsInspection, RubyInstanceMethodNamingConvention, RubyParameterNamingConvention
class WebDriver
  include WebdriverHelper
  include WebdriverJsMethods
  include WebdriverUserAgentHelper
  TIMEOUT_WAIT_ELEMENT = 15
  TIMEOUT_FILE_DOWNLOAD = 100
  # @return [Array, String] default switches for chrome
  DEFAULT_CHROME_SWITCHES = %w( --kiosk-printing --start-maximized --disable-popup-blocking test-type).freeze
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
    @device = device
    @headless = HeadlessHelper.new
    @headless.start

    ENV['SELENIUM_SERVER_JAR'] = LinuxHelper.shared_folder + 'Selenium/Server/selenium-server-standalone.jar'
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 480 # seconds

    @download_directory = FileHelper.init_download_directory
    @browser = browser
    @ip_of_remote_server = remote_server
    case browser
    when :firefox
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/doct, application/mspowerpoint, application/msword, application/octet-stream, application/oleobject, application/pdf, application/powerpoint, application/pptt, application/rtf, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/vnd.oasis.opendocument.spreadsheet, application/vnd.oasis.opendocument.text, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/x-compressed, application/x-excel, application/xlst, application/x-msexcel, application/x-mspowerpoint, application/x-rtf, application/x-zip-compressed, application/zip, image/jpeg, image/pjpeg, image/pjpeg, image/x-jps, message/rfc822, multipart/x-zip, text/csv, text/html, text/html, text/plain, text/richtext'
      profile['browser.download.dir'] = @download_directory
      profile['browser.download.manager.showWhenStarting'] = false
      profile['dom.disable_window_move_resize'] = false
      if remote_server.nil?
        @driver = Selenium::WebDriver.for :firefox, profile: profile, http_client: client
        @driver.manage.window.maximize
        if @headless.running?
          @driver.manage.window.size = Selenium::WebDriver::Dimension.new(@headless.resolution_x, @headless.resolution_y)
        end
      else
        capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_profile: profile)
        @driver = Selenium::WebDriver.for :remote, desired_capabilities: capabilities, http_client: client, url: 'http://' + remote_server + ':4444/wd/hub'
        @ip_of_remote_server = remote_server
      end
    when :chrome
      Selenium::WebDriver::Chrome::Service.executable_path = if LinuxHelper.os_64_bit?
                                                               File.join(File.dirname(__FILE__), '../assets/bin/x64/chromedriver')
                                                             else
                                                               File.join(File.dirname(__FILE__), '../assets/bin/x32/chromedriver')
                                                             end
      prefs = {
        download: {
          prompt_for_download: false,
          default_directory: @download_directory
        },
        profile: {
          default_content_settings: {
            'multiple-automatic-downloads' => 1
          }
        }
      }
      if remote_server.nil?
        switches = add_useragent_to_switches(DEFAULT_CHROME_SWITCHES)
        begin
          @driver = Selenium::WebDriver.for :chrome, prefs: prefs, switches: switches
          if @headless.running?
            @driver.manage.window.size = Selenium::WebDriver::Dimension.new(@headless.resolution_x, @headless.resolution_y)
          end
          @driver
        rescue Selenium::WebDriver::Error::WebDriverError, Net::ReadTimeout # Problems with Chromedriver - hang ups
          LinuxHelper.kill_all('chromedriver')
          sleep 5
          @driver = Selenium::WebDriver.for :chrome, prefs: prefs, switches: switches
          if @headless.running?
            @driver.manage.window.size = Selenium::WebDriver::Dimension.new(@headless.resolution_x, @headless.resolution_y)
          end
          @driver
        end
      else
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps['chromeOptions'] = {
          profile: data['zip'],
          extensions: data['extensions']
        }
        @driver = Selenium::WebDriver.for(:remote, url: 'http://' + remote_server + ':4444/wd/hub', desired_capabilities: caps)
      end
    when :opera
      raise 'ForMe:Implement remote for opera' unless remote_server.nil?
      @driver = Selenium::WebDriver.for :opera
    when :internet_explorer, :ie
      if remote_server.nil?
        @driver = Selenium::WebDriver.for :internet_explorer
      else
        caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
        caps.native_events = true
        @driver = Selenium::WebDriver.for(:remote,
                                          url: 'http://' + remote_server + ':4444/wd/hub',
                                          desired_capabilities: caps)
      end
    when :safari
      if remote_server.nil?
        @driver = Selenium::WebDriver.for :safari
      else
        caps = Selenium::WebDriver::Remote::Capabilities.safari
        @driver = Selenium::WebDriver.for(:remote,
                                          url: 'http://' + remote_server + ':4444/wd/hub',
                                          desired_capabilities: caps)
      end
    when :htmlunit
      caps = Selenium::WebDriver::Remote::Capabilities.htmlunit(javascript_enabled: true)
      @driver = Selenium::WebDriver.for(:remote, desired_capabilities: caps)
    else
      raise 'Unknown Browser: ' + browser.to_s
    end
  end

  def browser_size
    size_struct = @driver.manage.window.size
    size = CursorPoint.new(size_struct.width, size_struct.height)
    LoggerHelper.print_to_log("browser_size: #{size}")
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
    LoggerHelper.print_to_log("Opened page: #{url}")
  end

  def quit
    begin
      @driver.execute_script('window.onbeforeunload = null')
    rescue
      Exception
    end # OFF POPUP WINDOW
    begin
      @driver.quit
    rescue
      Exception
    end
    alert_confirm
    @headless.stop
  end

  def get_element(object_identification)
    return object_identification unless object_identification.is_a?(String)
    if @browser == :ie
      @driver.element(:xpath, object_identification).to_subtype
    else
      @driver.find_element(:xpath, object_identification)
    end
  rescue
    nil
  end

  def alert_confirm
    return if @browser == :ie
    begin
      @driver.switch_to.alert.accept
    rescue
      Selenium::WebDriver::Error::NoAlertOpenError
    end
  end

  # Check if alert exists
  # @return [True, false]
  def alert_exists?
    @driver.switch_to.alert.text
    true
  rescue Selenium::WebDriver::Error::NoAlertOpenError
    false
  end

  # Get alert text
  # @return [String] text inside alert
  def alert_text
    @driver.switch_to.alert.text
  end

  def set_text_to_iframe(element, text)
    element.click
    @driver.action.send_keys(text).perform
  end

  def send_keys(xpath_name, text_to_send, by_action = true)
    element = get_element(xpath_name)
    if @browser == :ie
      element.send_keys text_to_send
    else
      @driver.mouse.click(element) if @browser == :firefox
      if by_action
        @driver.action.send_keys(element, text_to_send).perform
      else
        element.send_keys text_to_send
      end
    end
  end

  def send_keys_to_focused_elements(keys, count_of_times = 1)
    if @browser != :ie
      command = @driver.action.send_keys(keys)
      (count_of_times - 1).times { command = command.send_keys(keys) }
      command.perform
    else
      count_of_times.times { @driver.send_keys keys }
    end
  end

  def press_key(key)
    @driver.action.send_keys(key).perform
  end

  def key_down(xpath, key)
    @driver.action.key_down(get_element(xpath), key).perform
  end

  def key_up(xpath, key)
    @driver.action.key_up(get_element(xpath), key).perform
  end

  def type_text(element, text_to_send, clear_area = false)
    element = get_element(element)
    element.clear if clear_area
    element.send_keys(text_to_send)
  end

  def type_text_and_select_it(element, text_to_send, clear_area = false)
    type_text(element, text_to_send, clear_area)
    text_to_send.length.times { element.send_keys [:shift, :left] }
  end

  def type_to_locator(xpath_name, text_to_send, clear_content = true, click_on_it = false, by_action = false, by_element_send_key = false)
    element = get_element(xpath_name)
    if clear_content
      begin
        element.clear
      rescue Exception => e
        webdriver_error("Error in element.clear #{e} for type_to_locator(#{xpath_name}, #{text_to_send}, #{clear_content}, #{click_on_it}, #{by_action}, #{by_element_send_key})")
      end
    end

    if click_on_it
      click_on_locator(xpath_name)
      sleep 0.2
    end

    if @browser != :ie
      if (@browser != :chrome && !by_action) || by_element_send_key
        element.send_keys text_to_send
      elsif text_to_send != ''
        if text_to_send.is_a?(String)
          text_to_send.split(//).each do |symbol|
            @driver.action.send_keys(symbol).perform
          end
        else
          @driver.action.send_keys(text_to_send).perform
        end
      end
    elsif text_to_send != ''
      begin
        element.set text_to_send
      rescue Exception
        element.send_keys text_to_send
      end
    end
  end

  def type_to_input(xpath_name, text_to_send, clear_content = false, click_on_it = true)
    element = get_element(xpath_name)
    webdriver_error(Selenium::WebDriver::Error::NoSuchElementError, "type_to_input(#{xpath_name}, #{text_to_send}, #{clear_content}, #{click_on_it}): element not found") if element.nil?
    element.clear if clear_content
    sleep 0.2
    if click_on_it
      begin
        element.click
      rescue Exception => e
        webdriver_error("type_to_input(#{xpath_name}, #{text_to_send}, #{clear_content}, #{click_on_it}) error in 'element.click' error: #{e}")
      end
      sleep 0.2
    end
    element.send_keys text_to_send
  end

  def type_text_by_symbol(xpath_name, text_to_send, clear_content = true, click_on_it = false, by_action = false, by_element_send_key = false)
    click_on_locator(xpath_name) if click_on_it
    element = get_element(xpath_name)
    if clear_content
      element.clear
      click_on_locator(xpath_name) if click_on_it
    end
    text_to_send.scan(/./).each do |symbol|
      sleep(0.3)
      if @browser != :ie
        if (@browser != :chrome && !by_action) || by_element_send_key
          send_keys(element, symbol, :element_send_key)
        else
          send_keys(element, symbol, by_action)
        end
      elsif text_to_send != ''
        begin
          send_keys(element, symbol, :ie_set)
        rescue Exception
          send_keys(element, symbol, :ie_send_keys)
        end
      end
    end
  end

  def get_text_array(array_elements)
    get_elements(array_elements).map { |current_element| get_text(current_element) }
  end

  def get_element_by_parameter(elements, parameter_name, value)
    elements.find { |current_element| value == get_attribute(current_element, parameter_name) }
  end

  def click(element)
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
    return if @browser == :ie
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
    LoggerHelper.print_to_log('Refresh page')
  end

  def go_back
    @driver.navigate.back
    LoggerHelper.print_to_log('Go back to previous page')
  end

  def self.host_name_by_full_url(full_url)
    uri = URI(full_url)
    uri.port == 80 || uri.port == 443 ? "#{uri.scheme}://#{uri.host}" : "#{uri.scheme}://#{uri.host}:#{uri.port}"
  end

  def get_host_name
    WebDriver.host_name_by_full_url(get_url)
  end

  def new_tab
    execute_javascript('window.open()')
  end

  def maximize
    @driver.manage.window.maximize
    LoggerHelper.print_to_log('Maximized current window')
  end

  def resize_tab(width, height)
    @driver.manage.window.resize_to(width, height)
    LoggerHelper.print_to_log("Resize current window to #{width}x#{height}")
  end

  def switch_to_popup
    if @browser != :ie
      counter = 0
      while tab_count < 2 && counter < 30
        sleep 1
        counter += 1
      end
      webdriver_error('switch_to_popup: Popup window not found') if counter >= 30
      list_of_handlers = @driver.window_handles
      last_window_handler = list_of_handlers.last
      @driver.switch_to.window(last_window_handler)
    else
      @driver.windows.last.use
    end
  end

  # Get tab count
  # @return [Integer] count of tabs in opened session
  def tab_count
    tab_count = @driver.window_handles.length
    LoggerHelper.print_to_log("tab_count: #{tab_count}")
    tab_count
  end

  def choose_tab(tab_number)
    counter = 0
    while tab_count < 2 && counter < TIMEOUT_WAIT_ELEMENT
      sleep 1
      counter += 1
    end
    webdriver_error("choose_tab: Tab number = #{tab_number} not found") if counter >= TIMEOUT_WAIT_ELEMENT
    @driver.switch_to.window(@driver.window_handles[tab_number - 1])
  end

  def switch_to_main_tab
    if @browser == :ie
      @driver.windows.last.close
      @driver.windows.first.use
    else
      @driver.switch_to.window(@driver.window_handles.first)
    end
  end

  def close_tab
    @driver.close
    sleep 1
    switch_to_main_tab
  end

  def close_window
    @driver.close
  end

  def close_popup_and_switch_to_main_tab
    switch_to_popup
    close_tab
    switch_to_main_tab
  end

  def get_title_of_current_tab
    @driver.title
  end

  def set_style_show_by_xpath(xpath, move_to_center = false)
    xpath.tr!("'", '"')
    execute_javascript('document.evaluate( \'' + xpath.to_s +
                         '\' ,document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null ).singleNodeValue.style.display = "block";')
    return unless move_to_center
    execute_javascript('document.evaluate( \'' + xpath.to_s +
                         '\' ,document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null ).singleNodeValue.style.left = "410px";')
    execute_javascript('document.evaluate( \'' + xpath.to_s +
                         '\' ,document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null ).singleNodeValue.style.top = "260px";')
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
    x1, y1 = round_coordinates(x1, y1)
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

  def get_screenshot_and_upload(path_to_screenshot = "/mnt/data_share/screenshot/WebdriverError/#{StringHelper.generate_random_string}.png")
    begin
      get_screenshot(path_to_screenshot)
      path_to_screenshot = AmazonS3Wrapper.new.upload_file_and_make_public(path_to_screenshot, 'screenshots')
      LoggerHelper.print_to_log("upload screenshot: #{path_to_screenshot}")
    rescue Errno::ENOENT => e
      begin
        @driver.save_screenshot(path_to_screenshot)
        LoggerHelper.print_to_log("Cant upload screenshot #{path_to_screenshot}. Error: #{e}")
      rescue Errno::ENOENT => e
        @driver.save_screenshot("tmp/#{File.basename(path_to_screenshot)}")
        LoggerHelper.print_to_log("Upload screenshot to tmp/#{File.basename(path_to_screenshot)}. Error: #{e}")
      end
    end
    path_to_screenshot
  end

  def get_screenshot(path_to_screenshot = "/mnt/data_share/screenshot/WebdriverError/#{StringHelper.generate_random_string}.png")
    FileHelper.create_folder(File.dirname(path_to_screenshot))
    @driver.save_screenshot(path_to_screenshot)
    LoggerHelper.print_to_log("get_screenshot(#{path_to_screenshot})")
  end

  # Open dropdown selector, like 'Color Selector', which has no element id
  # @param [String] xpath_name name of dropdown list
  def open_dropdown_selector(xpath_name, horizontal_shift = 30, vertical_shift = 0)
    element = get_element(xpath_name)
    horizontal_shift, vertical_shift = round_coordinates(horizontal_shift, vertical_shift)
    if @browser == :firefox || @browser == :safari
      set_style_attribute(xpath_name + '/button', 'display', 'none')
      set_style_attribute(xpath_name, 'display', 'inline')
      element.click
      set_style_attribute(xpath_name + '/button', 'display', 'inline-block')
      set_style_attribute(xpath_name, 'display', 'block')
    elsif @browser == :ie
      @driver.driver.action.move_to(element.wd, horizontal_shift, vertical_shift).click.perform
    else
      @driver.action.move_to(element, horizontal_shift, vertical_shift).click.perform
    end
  end

  # Click on locator
  def click_on_locator(xpath_name, non_iframe = false, by_fire_event = true, by_javascript = false)
    element = get_element(xpath_name)
    if element.nil?
      webdriver_error("Element with xpath: #{xpath_name} not found")
    elsif @browser != :ie
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
    elsif non_iframe
      element.click
    else
      click_on_locator_ie(element, by_fire_event)
    end
  end

  def left_mouse_click(xpath, x_coord, y_coord)
    x_coord, y_coord = round_coordinates(x_coord, y_coord)
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
      element.send_keys [:shift, :f10]
    else
      x_coord, y_coord = round_coordinates(x_coord, y_coord)
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

  def click_on_locator_ie(element, by_fire_event = true)
    if by_fire_event
      begin
        element.fire_event('onclick')
      rescue Exception
        element.click
      end
    else
      element.click
    end
  end

  def click_on_locator_coordinates(xpath_name, right_by, down_by)
    wait_until_element_visible(xpath_name)
    element = @driver.find_element(:xpath, xpath_name)
    right_by, down_by = round_coordinates(right_by, down_by)
    @driver.action.move_to(element, right_by, down_by).perform
    @driver.action.move_to(element, right_by, down_by).click.perform
  end

  def right_click_on_locator_coordinates(xpath_name, right_by = nil, down_by = nil)
    wait_until_element_visible(xpath_name)
    element = @driver.find_element(:xpath, xpath_name)
    right_by, down_by = round_coordinates(right_by, down_by)
    @driver.action.move_to(element, right_by, down_by).perform
    @driver.action.move_to(element, right_by, down_by).context_click.perform
  end

  def double_click(xpath_name)
    wait_until_element_visible(xpath_name)
    @driver.action.move_to(@driver.find_element(:xpath, xpath_name)).double_click.perform
  end

  def double_click_on_locator_coordinates(xpath_name, right_by, down_by)
    wait_until_element_visible(xpath_name)
    right_by, down_by = round_coordinates(right_by, down_by)
    @driver.action.move_to(@driver.find_element(:xpath, xpath_name), right_by, down_by).double_click.perform
  end

  def action_on_locator_coordinates(xpath_name, right_by, down_by, action = :click, times = 1)
    wait_until_element_visible(xpath_name)
    element = @driver.find_element(:xpath, xpath_name)
    right_by, down_by = round_coordinates(right_by, down_by)
    (0...times).inject(@driver.action.move_to(element, right_by, down_by)) { |a, _e| a.send(action) }.perform
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

  def click_on_one_of_several_xpath_by_number(xpath, number_of_element, by_javascript = false)
    click_on_locator("(#{xpath})[#{number_of_element}]", false, true, by_javascript)
  end

  def move_to_element(element)
    element = get_element(element) if element.is_a?(String)
    if @browser == :ie
      element.fire_event('onmouseover')
    else
      @driver.action.move_to(element).perform
    end
  end

  def move_to_element_by_locator(xpath_name)
    element = get_element(xpath_name)
    if @browser == :ie
      element.fire_event('onmouseover')
    else
      @driver.mouse.move_to(element)
    end
    LoggerHelper.print_to_log("Moved mouse to element: #{xpath_name}")
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
    x_coordinate, y_coordinate = round_coordinates(x_coordinate, y_coordinate)
    @driver.action.move_to(@driver.find_element(:xpath, xpath_name), x_coordinate, y_coordinate).perform
  end

  def element_present?(xpath_name)
    if xpath_name.is_a?(PageObject::Elements::Element)
      xpath_name.visible?
    elsif xpath_name.is_a?(Selenium::WebDriver::Element)
      xpath_name.displayed?
    else
      if @browser != :ie
        @driver.find_element(:xpath, xpath_name)
      else
        @driver.element(:xpath, xpath_name).to_subtype
      end
      true
    end
  rescue Exception
    false
  end

  def wait_until_element_present(xpath_name)
    if @browser == :ie
      get_element(xpath_name).wait_until_present(TIMEOUT_WAIT_ELEMENT)
    else
      wait = Selenium::WebDriver::Wait.new(timeout: TIMEOUT_WAIT_ELEMENT) # seconds
      begin
        wait.until { get_element(xpath_name) }
      rescue Selenium::WebDriver::Error::TimeOutError
        webdriver_error("wait_until_element_present(#{xpath_name}) Selenium::WebDriver::Error::TimeOutError: timed out after 15 seconds")
      end
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
    if @browser == :ie
      @driver.elements(:xpath, xpath_name).to_subtype.each do |element|
        return element if element.displayed?
      end
    else
      begin
        @driver.find_elements(:xpath, xpath_name).each do |element|
          return element if element.displayed?
        end
      rescue Selenium::WebDriver::Error::InvalidSelectorError
        webdriver_error("get_element_by_display(#{xpath_name}): invalid selector: Unable to locate an element with the xpath expression")
      end
    end
  end

  def get_element_count(xpath_name, only_visible = true)
    if element_present?(xpath_name)
      if @browser == :ie
        @driver.elements(:xpath, xpath_name).length
      else
        elements = @driver.find_elements(:xpath, xpath_name)
        only_visible ? elements.delete_if { |element| @browser == :firefox && !element.displayed? }.length : elements.length
      end
    else
      0
    end
  end

  def get_elements(objects_identification, only_visible = true)
    return objects_identification if objects_identification.is_a?(Array)
    if @browser == :ie
      elements = @driver.elements(:xpath, objects_identification)
    else
      elements = @driver.find_elements(:xpath, objects_identification)
      if only_visible
        elements.each do |current|
          elements.delete(current) unless @browser == :firefox || current.displayed?
        end
      end
    end
    elements
  end

  def get_index_of_elements_with_attribute(xpath, attribute, value, only_visible = true)
    get_elements(xpath, only_visible).each_with_index do |element, index|
      return (index + 1) if get_attribute(element, attribute).include?(value)
    end
    0
  end

  def element_visible?(xpath_name)
    if xpath_name.is_a?(PageObject::Elements::Element) # PageObject always visible
      true
    elsif element_present?(xpath_name)
      element = get_element(xpath_name)
      return false if element.nil?
      if @browser != :ie
        begin
          visible = element.displayed?
        rescue Exception
          visible = false
        end
      else
        visible = element.visible?
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
        LoggerHelper.print_to_log('Raise NoSuchElementError in the select_frame method')
      rescue Exception => e
        webdriver_error("Raise unkwnown exception: #{e}")
      end
    end
  end

  # Select top frame of browser (even if several subframes exists)
  def select_top_frame
    if @browser == :ie
      @driver = @driver.browser
    else
      begin
        @driver.switch_to.default_content
      rescue Timeout::Error
        LoggerHelper.print_to_log('Raise TimeoutError in the select_top_frame method')
      rescue Exception => e
        raise "Browser is crushed or hangup with error: #{e}"
      end
    end
  end

  # Get text of current element
  # @param [String] xpath_name name of xpath
  # @param [true, false] wait_until_visible wait until element visible [@default = true]
  def get_text(xpath_name, wait_until_visible = true)
    wait_until_element_visible(xpath_name) if wait_until_visible

    element = get_element(xpath_name)
    webdriver_error("get_text(#{xpath_name}, #{wait_until_visible}) not found element by xpath") if element.nil?
    if element.tag_name == 'input' || element.tag_name == 'textarea'
      if @browser == :ie
        element
      else
        element.attribute('value')
      end
    else
      element.text
    end
  end

  def get_text_of_several_elements(xpath_several_elements)
    @driver.find_elements(:xpath, xpath_several_elements).map { |element| element.text unless element.text == '' }.compact
  end

  def attribute_exist?(xpath_name, attribute)
    exist = false

    element = xpath_name.is_a?(String) ? get_element(xpath_name) : xpath_name
    if @browser == :ie
      begin
        element.attribute_value(attribute)
        exist = true
      rescue Exception
        exist = false
      end
    else
      begin
        attribute_value = element.attribute(attribute)
        exist = attribute_value.empty? || attribute_value.nil? ? false : true
      rescue Exception
        exist = false
      end
    end
    exist
  end

  def get_attribute(xpath_name, attribute)
    element = xpath_name.is_a?(Selenium::WebDriver::Element) ? xpath_name : get_element(xpath_name)

    if element.nil?
      webdriver_error("Webdriver.get_attribute(#{xpath_name}, #{attribute}) failed because element not found")
    else
      @browser == :ie ? element.attribute_value(attribute) : element.attribute(attribute)
    end
  end

  def get_attribute_from_displayed_element(xpath_name, attribute)
    @driver.find_elements(:xpath, xpath_name).each do |current_element|
      return current_element.attribute(attribute) if current_element.displayed?
    end
    false
  end

  def get_attributes_of_several_elements(xpath_several_elements, attribute)
    elements = @browser == :ie ? @driver.elements(:xpath, xpath_several_elements) : @driver.find_elements(:xpath, xpath_several_elements)

    elements.map do |element|
      @browser == :ie ? element.attribute_value(attribute) : element.attribute(attribute)
    end
  end

  def get_style_parameter(xpath, parameter_name)
    get_attribute(xpath, 'style').split(';').each do |current_param|
      return /:\s(.*);?$/.match(current_param)[1] if current_param.include?(parameter_name)
    end
  end

  def get_style_attributes_of_several_elements(xpath_several_elements, style)
    if @browser == :ie
      @driver.elements(:xpath, xpath_several_elements).map { |element| element.attribute_value(attribute) }.compact
    else
      @driver.find_elements(:xpath, xpath_several_elements).map do |element|
        el_style = element.attribute('style')
        unless el_style.empty?
          found_style = el_style.split(';').find { |curr_param| curr_param.include?(style) }
          found_style.gsub(/\s?#{ style }:/, '') unless found_style.nil?
        end
      end.compact
    end
  end

  def set_parameter(xpath, attribute, attribute_value)
    execute_javascript("document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext()." \
                           "#{attribute}=\"#{attribute_value}\";")
  end

  def set_style_parameter(xpath, attribute, attribute_value)
    execute_javascript("document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext()." \
                           "style.#{attribute}=\"#{attribute_value}\"")
  end

  def set_style_attribute(xpath, attribute, attribute_value)
    execute_javascript("document.evaluate('#{xpath}',document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)." \
                           "singleNodeValue.style.#{attribute}=\"#{attribute_value}\"")
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

  def webdriver_screenshot(screenshot_name = StringHelper.generate_random_string(12))
    begin
      link = get_screenshot_and_upload("/mnt/data_share/screenshot/WebdriverError/#{screenshot_name}.png")
    rescue Exception
      if @headless.headless_instance.nil?
        LinuxHelper.take_screenshot("/tmp/#{screenshot_name}.png")
        begin
          link = AmazonS3Wrapper.new.upload_file_and_make_public("/tmp/#{screenshot_name}.png", 'screenshots')
        rescue Exception => e
          LoggerHelper.print_to_log("Error in get screenshot: #{e}. System screenshot #{link}")
        end
      else
        @headless.take_screenshot("/tmp/#{screenshot_name}.png")
        begin
          link = AmazonS3Wrapper.new.upload_file_and_make_public("/tmp/#{screenshot_name}.png", 'screenshots')
        rescue Exception => e
          LoggerHelper.print_to_log("Error in get screenshot: #{e}. Headless screenshot #{link}")
        end
      end
    end
    "screenshot: #{link}"
  end

  def wait_until(timeout = ::PageObject.default_page_wait, message = nil, &block)
    wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: message)
    begin
      wait.until(&block)
      wait.until { execute_javascript('return document.readyState;') == 'complete' }
    rescue Selenium::WebDriver::Error::TimeOutError
      webdriver_error("Wait until timeout: #{timeout} seconds in")
    end
  end

  def wait_file_for_download(file_name, timeout = TIMEOUT_FILE_DOWNLOAD)
    full_file_name = "#{@download_directory}/#{file_name}"
    full_file_name = file_name if file_name[0] == '/'
    counter = 0
    while !File.exist?(full_file_name) && counter < timeout
      LoggerHelper.print_to_log("Waiting for download file #{full_file_name} for #{counter} of #{timeout}")
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

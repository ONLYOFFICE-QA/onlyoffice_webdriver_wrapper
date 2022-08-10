# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for helping with type stuff
  module WebdriverTypeHelper
    # Type text to element
    # @param [String] element to find object
    # @param [String] text_to_send text to type
    # @param [Boolean] clear_area should area be cleared
    # @return [void]
    def type_text(element, text_to_send, clear_area = false)
      element = get_element(element)
      element.clear if clear_area
      element.send_keys(text_to_send)
    end

    # Type text to element and select it
    # @param [String] element to find object
    # @param [String] text_to_send text to type
    # @param [Boolean] clear_area should area be cleared
    # @return [void]
    def type_text_and_select_it(element, text_to_send, clear_area = false)
      type_text(element, text_to_send, clear_area)
      text_to_send.length.times { element.send_keys %i[shift left] }
    end

    # Type text to object
    # @param [String] xpath_name to find object
    # @param [String] text_to_send text to type
    # @param [Boolean] clear_content should content be cleared
    # @param [Boolean] click_on_it should object be clicked
    # @param [Boolean] by_action type by `@driver.action` if true
    # @param [Boolean] by_element_send_key use `element.send_keys` if true
    # @return [void]
    def type_to_locator(xpath_name,
                        text_to_send,
                        clear_content = true,
                        click_on_it = false,
                        by_action = false,
                        by_element_send_key = false)
      element = get_element(xpath_name)
      if clear_content
        begin
          element.clear
        rescue StandardError => e
          webdriver_error(e.class, "Error in element.clear #{e} for " \
                                   "type_to_locator(#{xpath_name}, #{text_to_send}, " \
                                   "#{clear_content}, #{click_on_it}, " \
                                   "#{by_action}, #{by_element_send_key})")
        end
      end

      if click_on_it
        click_on_locator(xpath_name)
        sleep 0.2
      end

      if (@browser != :chrome && !by_action) || by_element_send_key
        element.send_keys text_to_send
      elsif text_to_send != ''
        if text_to_send.is_a?(String)
          text_to_send.chars.each do |symbol|
            @driver.action.send_keys(symbol).perform
          end
        else
          webdriver_bug_8179_workaround(text_to_send)
        end
      end
    end

    # Type text to input
    # @param [String] xpath_name to find object
    # @param [String] text_to_send text to type
    # @param [Boolean] clear_content should content be cleared
    # @param [Boolean] click_on_it should object be clicked
    # @return [void]
    def type_to_input(xpath_name, text_to_send, clear_content = false, click_on_it = true)
      element = get_element(xpath_name)
      if element.nil?
        webdriver_error(Selenium::WebDriver::Error::NoSuchElementError,
                        "type_to_input(#{xpath_name}, #{text_to_send}, " \
                        "#{clear_content}, #{click_on_it}): element not found")
      end
      element.clear if clear_content
      sleep 0.2
      if click_on_it
        begin
          element.click
        rescue StandardError => e
          webdriver_error(e.class,
                          "type_to_input(#{xpath_name}, #{text_to_send}, " \
                          "#{clear_content}, #{click_on_it}) " \
                          "error in 'element.click' error: #{e}")
        end
        sleep 0.2
      end
      element.send_keys text_to_send
    end

    # Send keys to object
    # @param [String] xpath_name to find object
    # @param [String] text_to_send text to type
    # @param [Boolean] by_action type by `@driver.action` if true
    # @return [void]
    def send_keys(xpath_name, text_to_send, by_action = true)
      element = get_element(xpath_name)
      @driver.action.click(element).perform if @browser == :firefox
      if by_action
        @driver.action.send_keys(element, text_to_send).perform
      else
        element.send_keys text_to_send
      end
    end

    # Type text to currently focused element
    # @param [Array<String, Symbol>, String, Symbol] keys to send
    # @param [Integer] count_of_times how much times to repeat
    # @return [void]
    def send_keys_to_focused_elements(keys, count_of_times = 1)
      command = @driver.action.send_keys(keys)
      (count_of_times - 1).times { command = command.send_keys(keys) }
      command.perform
    end

    # Press some specific key
    # @param [String, Symbol] key to press
    # @return [void]
    def press_key(key)
      @driver.action.send_keys(key).perform
    end

    # Simulate pressed down key on object
    # @param [String] xpath to find object
    # @param [String, Symbol] key to press
    # @return [void]
    def key_down(xpath, key)
      @driver.action.key_down(get_element(xpath), key).perform
      sleep(1) # for some reason quick key_down select text in control
    end

    # Release pressed key from object
    # @param [String] xpath to find object
    # @param [String, Symbol] key to release
    # @return [void]
    def key_up(xpath, key)
      @driver.action.key_up(get_element(xpath), key).perform
    end

    private

    # Workaround for bug with typing with :control
    # See https://github.com/SeleniumHQ/selenium/issues/8179
    # for more details
    # @param [String] text_to_send text to type
    # @return [void]
    def webdriver_bug_8179_workaround(text_to_send)
      text_to_send = [text_to_send].flatten

      key_modifiers = text_to_send.select { |i| i.is_a?(Symbol) }
      letters = text_to_send - key_modifiers

      key_modifiers.each do |modifier|
        @driver.action.key_down(modifier).perform
      end

      letters.each do |letter|
        @driver.action.send_keys(letter.to_s).perform
      end

      key_modifiers.each do |modifier|
        @driver.action.key_up(modifier).perform
      end
    end
  end
end

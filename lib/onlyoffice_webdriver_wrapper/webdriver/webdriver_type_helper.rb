# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for helping with type stuff
  module WebdriverTypeHelper
    def type_text(element, text_to_send, clear_area = false)
      element = get_element(element)
      element.clear if clear_area
      element.send_keys(text_to_send)
    end

    def type_text_and_select_it(element, text_to_send, clear_area = false)
      type_text(element, text_to_send, clear_area)
      text_to_send.length.times { element.send_keys %i[shift left] }
    end

    def type_to_locator(xpath_name, text_to_send, clear_content = true, click_on_it = false, by_action = false, by_element_send_key = false)
      element = get_element(xpath_name)
      if clear_content
        begin
          element.clear
        rescue Exception => e
          webdriver_error(e.class, "Error in element.clear #{e} for "\
                          "type_to_locator(#{xpath_name}, #{text_to_send}, "\
                          "#{clear_content}, #{click_on_it}, "\
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
          text_to_send.split(//).each do |symbol|
            @driver.action.send_keys(symbol).perform
          end
        else
          webdriver_bug_8179_workaround(text_to_send)
        end
      end
    end

    def type_to_input(xpath_name, text_to_send, clear_content = false, click_on_it = true)
      element = get_element(xpath_name)
      if element.nil?
        webdriver_error(Selenium::WebDriver::Error::NoSuchElementError,
                        "type_to_input(#{xpath_name}, #{text_to_send}, "\
                        "#{clear_content}, #{click_on_it}): element not found")
      end
      element.clear if clear_content
      sleep 0.2
      if click_on_it
        begin
          element.click
        rescue Exception => e
          webdriver_error(e.class, "type_to_input(#{xpath_name}, #{text_to_send}, #{clear_content}, #{click_on_it}) error in 'element.click' error: #{e}")
        end
        sleep 0.2
      end
      element.send_keys text_to_send
    end

    def send_keys(xpath_name, text_to_send, by_action = true)
      element = get_element(xpath_name)
      @driver.action.click(element).perform if @browser == :firefox
      if by_action
        @driver.action.send_keys(element, text_to_send).perform
      else
        element.send_keys text_to_send
      end
    end

    def send_keys_to_focused_elements(keys, count_of_times = 1)
      command = @driver.action.send_keys(keys)
      (count_of_times - 1).times { command = command.send_keys(keys) }
      command.perform
    end

    def press_key(key)
      @driver.action.send_keys(key).perform
    end

    def key_down(xpath, key)
      @driver.action.key_down(get_element(xpath), key).perform
      sleep(1) # for some reason quick key_down select text in control
    end

    def key_up(xpath, key)
      @driver.action.key_up(get_element(xpath), key).perform
    end

    private

    # Workaround for bug with typing with :control
    # See https://github.com/SeleniumHQ/selenium/issues/8179
    # for more details
    def webdriver_bug_8179_workaround(text_to_send)
      text_to_send = [text_to_send].flatten

      key_modifiers = text_to_send.select { |i| i.is_a?(Symbol) }
      letters = text_to_send - key_modifiers

      key_modifiers.each do |modifier|
        @driver.action.key_down(modifier).perform
      end

      @driver.action.send_keys(letters).perform

      key_modifiers.each do |modifier|
        @driver.action.key_up(modifier).perform
      end
    end
  end
end

# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Method to perform different clicks
  module ClickMethods
    # Click on specified element
    # @param element [Selenium::WebDriver::Element] element to click
    # @return [nil] nothing
    def click(element)
      element.click
    end

    # Click on locator
    # @param xpath_name [String] xpath to click
    # @param by_javascript [True, False] should be clicked by javascript
    # @param count [Integer] count of clicks
    def click_on_locator(xpath_name, by_javascript = false, count: 1)
      element = get_element(xpath_name)
      return webdriver_error("Element with xpath: #{xpath_name} not found") if element.nil?

      if by_javascript
        execute_javascript("document.evaluate(\"#{xpath_name}\", document, null, XPathResult.ANY_TYPE, null).iterateNext().click();")
      else
        begin
          count.times { element.click }
        rescue Selenium::WebDriver::Error::ElementNotVisibleError => e
          webdriver_error(e.class, "Selenium::WebDriver::Error::ElementNotVisibleError: element not visible for xpath: #{xpath_name}")
        rescue Exception => e
          webdriver_error(e.class, "UnknownError #{e.message} #{xpath_name}")
        end
      end
    end

    # Click on one of several which displayed
    # @param xpath_name [String] xpath to find element
    # @return [nil]
    def click_on_displayed(xpath_name)
      element = get_element_by_display(xpath_name)
      begin
        element.is_a?(Array) ? element.first.click : element.click
      rescue Exception => e
        webdriver_error(e.class, "Exception #{e} in click_on_displayed(#{xpath_name})")
      end
    end

    # Click on locator by coordinates
    # @param xpath_name [String] xpath to click
    # @param right_by [Integer] shift to right
    # @param down_by [Integer] shift to bottom
    # @return [nil]
    def click_on_locator_coordinates(xpath_name, right_by, down_by)
      wait_until_element_visible(xpath_name)
      element = @driver.find_element(:xpath, xpath_name)
      @driver.action.move_to(element, right_by.to_i, down_by.to_i).perform
      @driver.action.move_to(element, right_by.to_i, down_by.to_i).click.perform
    end

    # Click on one of several which displayed
    # @param xpath_several_elements [String] xpath to find element
    # @return [True, False] true if click successful, false if not found
    def click_on_one_of_several_by_display(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if current_element.displayed?
          current_element.click
          return true
        end
      end
      false
    end

    # Click on one of several xpath filtered by parameter and value
    # @param xpath_several_elements [String] xpath to select
    # @param parameter_name [String] parameter name
    # @param parameter_value [String] parameter value
    # @return [True, False] true if click successful, false if not found
    def click_on_one_of_several_by_parameter(xpath_several_elements, parameter_name, parameter_value)
      @driver.find_elements(:xpath, xpath_several_elements).each do |current_element|
        if current_element.attribute(parameter_name).include? parameter_value
          current_element.click
          return true
        end
      end
      false
    end

    # Perform right click on xpath
    # @param xpath_name [String] xpath to click
    # @return [nil]
    def right_click(xpath_name)
      @driver.action.context_click(@driver.find_element(:xpath, xpath_name)).perform
    end

    # Perform right click on locator with specified coordinates
    # @param xpath_name [String] xpath to click
    # @param right_by [Integer] shift to right
    # @param down_by [Integer] shift to bottom
    # @return [nil]
    def right_click_on_locator_coordinates(xpath_name, right_by = nil, down_by = nil)
      wait_until_element_visible(xpath_name)
      element = @driver.find_element(:xpath, xpath_name)
      @driver.action.move_to(element, right_by.to_i, down_by.to_i).perform
      @driver.action.move_to(element, right_by.to_i, down_by.to_i).context_click.perform
    end

    # Perform double_click on element
    # @param xpath_name [String] xpath to click
    # @return [nil]
    def double_click(xpath_name)
      wait_until_element_visible(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name)).double_click.perform
    end

    def double_click_on_locator_coordinates(xpath_name, right_by, down_by)
      wait_until_element_visible(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name), right_by.to_i, down_by.to_i).double_click.perform
    end

    def left_mouse_click(xpath, x_coord, y_coord)
      @driver.action.move_to(get_element(xpath), x_coord.to_i, y_coord.to_i).click.perform
    end

    # Context click on locator
    # @param [String] xpath_name name of xpath to click
    def context_click_on_locator(xpath_name)
      wait_until_element_visible(xpath_name)

      element = @driver.find_element(:xpath, xpath_name)
      @driver.action.context_click(element).perform
    end
  end
end

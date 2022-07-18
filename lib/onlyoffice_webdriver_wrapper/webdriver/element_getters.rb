# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods to get elements
  module ClickMethods
    # Get element by it's xpath
    # @param [String] object_identification xpath of object to find
    # @return [Object, nil] nil if nothing found
    def get_element(object_identification)
      return object_identification unless object_identification.is_a?(String)

      @driver.find_element(:xpath, object_identification)
    rescue StandardError
      nil
    end

    # Get first visible element from several
    # @param [String] xpath_name to find several objects
    # @raise [Selenium::WebDriver::Error::InvalidSelectorError] if selector is invalid
    # @return [Object] first visible element
    def get_element_by_display(xpath_name)
      @driver.find_elements(:xpath, xpath_name).each do |element|
        return element if element.displayed?
      end
    rescue Selenium::WebDriver::Error::InvalidSelectorError
      webdriver_error(Selenium::WebDriver::Error::InvalidSelectorError,
                      "Invalid Selector: get_element_by_display('#{xpath_name}')")
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
  end
end

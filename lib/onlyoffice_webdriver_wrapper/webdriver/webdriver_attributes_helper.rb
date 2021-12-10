# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Module with methods to work with attributes
  module WebdriverAttributesHelper
    # Check if attribute of xpath is exists
    # @param [String] xpath_name to find object
    # @param [String] attribute name to check
    # @return [Boolean] result of check
    def attribute_exist?(xpath_name, attribute)
      exist = false

      element = xpath_name.is_a?(String) ? get_element(xpath_name) : xpath_name
      begin
        attribute_value = element.attribute(attribute)
        exist = !(attribute_value.empty? || attribute_value.nil?)
      rescue Exception
        exist = false
      end
      exist
    end

    # Get attribute of element
    # @param [String] xpath_name to find object
    # @param [String] attribute to get
    # @return [String] value of attribute
    def get_attribute(xpath_name, attribute)
      element = xpath_name.is_a?(Selenium::WebDriver::Element) ? xpath_name : get_element(xpath_name)

      if element.nil?
        webdriver_error("Webdriver.get_attribute(#{xpath_name}, #{attribute}) failed because element not found")
      else
        element.attribute(attribute)
      end
    end

    # Get attributes of several elements
    # @param [String] xpath_several_elements to find objects
    # @param [String] attribute to get
    # @return [Array<String>] list of attributes
    def get_attributes_of_several_elements(xpath_several_elements, attribute)
      elements = @driver.find_elements(:xpath, xpath_several_elements)

      elements.map do |element|
        element.attribute(attribute)
      end
    end

    # Get index of element from array with attrribute value
    # @param [String] xpath to find objects
    # @param [String] attribute to check
    # @param [String] value to compare
    # @param [String] only_visible ignore invisible elements unless only_visible
    # @return [Integer] index of element or `0` if not found
    def get_index_of_elements_with_attribute(xpath, attribute, value, only_visible = true)
      get_elements(xpath, only_visible).each_with_index do |element, index|
        return (index + 1) if get_attribute(element, attribute).include?(value)
      end
      0
    end

    # Set element attribute
    # @param xpath [String] element to select
    # @param attribute [String] attribute to set
    # @param attribute_value [String] value of attribute
    # @return [String] result of execution
    def set_attribute(xpath, attribute, attribute_value)
      execute_javascript("#{dom_element_by_xpath(xpath)}.#{attribute}=\"#{attribute_value}\";")
    end

    alias set_parameter set_attribute

    # Remove attribute of element
    # @param xpath [String] xpath of element
    # @param attribute [String] attribute to remove
    # @return [String] result of execution
    def remove_attribute(xpath, attribute)
      execute_javascript("#{dom_element_by_xpath(xpath)}.removeAttribute('#{attribute}');")
    end
  end
end

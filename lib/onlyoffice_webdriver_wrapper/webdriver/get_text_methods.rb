# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Method to get text
  module GetTextMethods
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

    # Get text in object by xpath
    # @param xpath [String] xpath to get text
    # @return [String] text in xpath
    def get_text_by_js(xpath)
      text = execute_javascript("return #{dom_element_by_xpath(xpath)}.textContent")
      text = execute_javascript("return #{dom_element_by_xpath(xpath)}.value") if text.empty?
      text
    end

    # Get text from all elements with specified xpath
    # @param array_elements [String] xpath of elements
    # @return [Array<String>] values of elements
    def get_text_array(array_elements)
      get_elements(array_elements).map { |current_element| get_text(current_element) }
    end

    # Get text from several elements
    # This method filter out all elements with empty text
    # @param [String] xpath_several_elements to find objects
    # @return [Array<String>] text of those elements
    def get_text_of_several_elements(xpath_several_elements)
      @driver.find_elements(:xpath, xpath_several_elements).filter_map { |element| element.text unless element.text == '' }
    end
  end
end

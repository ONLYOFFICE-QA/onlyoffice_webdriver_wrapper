# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Webdriver style helper
  module WebdriverStyleHelper
    def get_style_parameter(xpath, parameter_name)
      get_attribute(xpath, 'style').split(';').each do |current_param|
        return /:\s(.*);?$/.match(current_param)[1] if current_param.include?(parameter_name)
      end
      nil
    end

    # Set style attribute value of element
    # @param xpath [String] xpath to set
    # @param attribute [String] style param to set
    # @param attribute_value [String] attribute value to set
    # @return [String] result of execution
    def set_style_attribute(xpath, attribute, attribute_value)
      execute_javascript("#{dom_element_by_xpath(xpath)}.style.#{attribute}=\"#{attribute_value}\"")
    end

    alias set_style_parameter set_style_attribute

    def set_style_show_by_xpath(xpath, move_to_center = false)
      execute_javascript("#{dom_element_by_xpath(xpath)}.style.display = 'block';")
      return unless move_to_center

      execute_javascript("#{dom_element_by_xpath(xpath)}.style.left = '410px';")
      execute_javascript("#{dom_element_by_xpath(xpath)}.style.top = '260px';")
    end
  end
end

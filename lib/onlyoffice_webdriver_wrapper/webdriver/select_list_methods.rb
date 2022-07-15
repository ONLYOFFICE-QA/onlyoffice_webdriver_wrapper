# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Method to work with select list
  module SelectListMethods
    # Select from list elements
    # @param [String] value value to find object
    # @param [Array<PageObject::Elements::Element>] elements_value `elements` page object to select from
    # @raise [SelectEntryNotFound] if value not found in select list
    # @return [void]
    def select_from_list_elements(value, elements_value)
      index = get_element_index(value, elements_value)
      webdriver_error(SelectEntryNotFound, "Select entry `#{value}` not found in #{elements_value}") if index.nil?

      elements_value[index].click
    end

    # Get index of element by it's text
    # @param [String] text to compare text
    # @param [Array<PageObject::Elements::Element>] list_elements array with
    #   PageObject elements to find in
    # @return [Integer, nil] nil if nothing found, index if found
    def get_element_index(text, list_elements)
      list_elements.each_with_index do |current, i|
        return i if get_text(current) == text
      end
      nil
    end

    # Get all options for combobox or select
    # @param [String] xpath_name to find element
    # @return [Array<String>] values
    def get_all_combo_box_values(xpath_name)
      @driver.find_element(:xpath, xpath_name).find_elements(tag_name: 'option').map { |el| el.attribute('value') }
    end

    # Select value of combo box
    # @param [String] xpath_name to find combobox
    # @param [String] select_value to select
    # @param [Symbol] select_by select type, can be `:value` or `:text`
    # @return [void]
    def select_combo_box(xpath_name, select_value, select_by = :value)
      wait_until_element_visible(xpath_name)
      option = Selenium::WebDriver::Support::Select.new(get_element(xpath_name))
      begin
        option.select_by(select_by, select_value)
      rescue StandardError
        option.select_by(:text, select_value)
      end
    end
  end
end

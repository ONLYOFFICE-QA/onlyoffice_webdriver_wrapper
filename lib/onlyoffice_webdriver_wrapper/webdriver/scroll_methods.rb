# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for scrolling page
  module ScrollMethods
    # Scroll list by pixel count
    # @param [String] list_xpath how to detect this list
    # @param [Integer] pixels how much to scroll
    # @return [void]
    def scroll_list_by_pixels(list_xpath, pixels)
      element = dom_element_by_xpath(list_xpath)
      execute_javascript("$(#{element}).scrollTop(#{pixels})")
    end

    # Get current element scroll position
    # @param [String] list_xpath how to detect this list
    # @return [Float] position in pixels
    def current_scroll_position(xpath)
      execute_javascript("return $(#{dom_element_by_xpath(xpath)}).scrollTop()")
    end
  end
end

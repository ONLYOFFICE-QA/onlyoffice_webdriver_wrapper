# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for webdriver to move cursor
  module WebdriverMoveCursorMethods
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

      move_action = @driver.action
                           .move_to(canvas, x1.to_i, y1.to_i)
                           .click_and_hold
                           .move_by(x2, y2)
      move_action = move_action.release if mouse_release

      move_action.perform
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

    # Move cursor to element
    # @param [String, Selenium::WebDriver::Element] element xpath or webdriver element
    # @return [nil]
    def move_to_element(element)
      element = get_element(element) if element.is_a?(String)
      @driver.action.move_to(element).perform
    end

    # Move cursor to element
    # @param [String] xpath_name
    # @return [nil]
    def move_to_element_by_locator(xpath_name)
      element = get_element(xpath_name)
      @driver.action.move_to(element).perform
      OnlyofficeLoggerHelper.log("Moved mouse to element: #{xpath_name}")
    end

    # Move mouse over element
    # @param [String] xpath_name element to move
    # @param [Integer] x_coordinate position relate to center of element
    # @param [Integer] y_coordinate position relate to center of element
    # @return [nil]
    def mouse_over(xpath_name, x_coordinate = 0, y_coordinate = 0)
      wait_until_element_present(xpath_name)
      @driver.action.move_to(@driver.find_element(:xpath, xpath_name), x_coordinate.to_i, y_coordinate.to_i).perform
    end
  end
end

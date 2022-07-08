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
    def drag_and_drop(xpath, x1, _y1, x2, y2, mouse_release: true)
      move_action = move_to_driver_action(xpath, x1, x2)
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
      shift_to_zero = move_to_shift_to_top_left(source)
      @driver.action.drag_and_drop_by(get_element(source),
                                      right_by - shift_to_zero.x,
                                      down_by - shift_to_zero.y).perform
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
      move_to_driver_action(xpath_name, x_coordinate, y_coordinate).perform
    end

    private

    # Since v4.3.0 of `webdriver` gem `move_to` method is moving
    # from the center of the element
    # Add additional negative shift if this version is used
    def move_to_shift_to_top_left(xpath)
      if Gem.loaded_specs['selenium-webdriver'].version >= Gem::Version.new('4.3.0')
        element_size = element_size_by_js(xpath)
        Dimensions.new(element_size.x / 2, element_size.y / 2)
      else
        Dimensions.new(0, 0)
      end
    end

    # Generate action to move cursor to element
    # @param [String] xpath xpath to move
    # @param [Integer] right_by shift vector x coordinate
    # @param [Integer] down_by shift vector y coordinate
    # @return [Selenium::WebDriver::ActionBuilder] object to perform actions
    def move_to_driver_action(xpath, right_by, down_by)
      element = @driver.find_element(:xpath, xpath)
      shift_to_zero = move_to_shift_to_top_left(xpath)
      @driver.action.move_to(element,
                             right_by.to_i - shift_to_zero.x,
                             down_by.to_i - shift_to_zero.y)
    end
  end
end

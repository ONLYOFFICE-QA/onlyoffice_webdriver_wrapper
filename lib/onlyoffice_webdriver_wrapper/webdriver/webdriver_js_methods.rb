# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for webdriver for calling Javascript
  module WebdriverJsMethods
    # Execute javascript
    # @param script [String] code to execute
    # @param wait_timeout [Integer] wait after JS is executed.
    #   Some code require some time to execute
    def execute_javascript(script, wait_timeout: 0)
      result = @driver.execute_script(script)
      OnlyofficeLoggerHelper.log("Executed js: `#{script}` with result: `#{result}`")
      sleep(wait_timeout)
      result
    rescue Timeout::Error => e
      # Usually this mean browser hang up or some modular
      # window is blocking browser for execution of any code
      # in that case performing `webdriver_error` only cause forever loop
      # since webdriver_error trying to get_url or make screenshots
      raise(e.class, "Timeout Error #{e} happened while executing #{script}")
    rescue StandardError => e
      webdriver_error(e, "Exception #{e} in execute_javascript: #{script}")
    end

    # @param [String] xpath element to select
    # @return [String] string to select dom by xpath
    def dom_element_by_xpath(xpath)
      escaped_xpath = xpath.tr('"', "'")
      "document.evaluate(\"#{escaped_xpath}\", document, null, XPathResult.ANY_TYPE, null).iterateNext()"
    end

    # Type to locator by javascript
    # @param [String] xpath to find object where to type
    # @param [String] text to type
    # @return [void]
    def type_to_locator_by_javascript(xpath, text)
      escaped_text = text.gsub('\\', '\\\\\\\\')
                         .gsub('"', '\\"')
                         .gsub("\n", '\\n')
      execute_javascript("#{dom_element_by_xpath(xpath)}.value=\"#{escaped_text}\";")
    end

    # Calculate object size using Javascript
    # @param xpath [Sting] xpath of object
    # @return [Dimensions] size of element
    def element_size_by_js(xpath)
      width = execute_javascript("return #{dom_element_by_xpath(xpath)}.offsetWidth")
      height = execute_javascript("return #{dom_element_by_xpath(xpath)}.offsetHeight")
      Dimensions.new(width, height)
    end

    # Get object absolute position from top left edge of screen
    # @param xpath [Sting] xpath of object
    # @return [CursorPoint] position of element
    def object_absolute_position(xpath)
      bounding = "#{dom_element_by_xpath(xpath)}.getBoundingClientRect()"
      left = execute_javascript("return #{bounding}.left")
      top = execute_javascript("return #{bounding}.top")
      Dimensions.new(left, top)
    end

    # @return [True, False] is page have jquery loaded
    def jquery_loaded?
      loaded = execute_javascript('return !!window.jQuery')
      OnlyofficeLoggerHelper.log("jquery_loaded? # #{loaded}")
      loaded
    end

    # Checks for jQuery finished its job or not present
    def jquery_finished?
      return true unless jquery_loaded?

      execute_javascript('return window.jQuery.active;').zero?
    end

    # @return [Boolean] Is document is ready, finished to be loading
    def document_ready?
      execute_javascript('return document.readyState;') == 'complete'
    end

    # Get ComputedStyle property value
    # @param xpath [String] xpath of element
    # @param pseudo_element [String] pseudo element to compute
    # @param property [String] property to get
    # @return [String] value of property
    def computed_style(xpath, pseudo_element = 'null', property = nil)
      element_by_xpath = dom_element_by_xpath(xpath)
      style = "window.getComputedStyle(#{element_by_xpath}, '#{pseudo_element}')"
      full_command = "#{style}.getPropertyValue('#{property}')"
      result = execute_javascript("return #{full_command}")
      result.delete('"')
    end

    # Remove element by its xpath
    # @param [String] xpath of element to remove
    # @return [String] result of javascript execution
    def remove_element(xpath)
      script = "element = #{dom_element_by_xpath(xpath)};" \
               'if (element !== null) ' \
               '{element.parentNode.removeChild(element);};'
      execute_javascript(script)
    end
  end
end

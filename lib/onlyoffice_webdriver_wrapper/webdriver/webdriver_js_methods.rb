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
    rescue Exception => e
      webdriver_error("Exception #{e} in execute_javascript: #{script}")
    end

    # @param [String] xpath element to select
    # @return [String] string to select dom by xpath
    def dom_element_by_xpath(xpath)
      escaped_xpath = xpath.tr('"', "'")
      "document.evaluate(\"#{escaped_xpath}\", document, null, XPathResult.ANY_TYPE, null).iterateNext()"
    end

    def type_to_locator_by_javascript(xpath_name, text)
      escaped_text = text.gsub('\\', '\\\\\\\\').gsub('"', '\\"').gsub("\n", '\\n')
      execute_javascript("document.evaluate('#{xpath_name}', document, null, XPathResult.ANY_TYPE, null).iterateNext().value=\"#{escaped_text}\";")
    end

    def get_text_by_js(xpath)
      text = execute_javascript("return #{dom_element_by_xpath(xpath)}.textContent")
      text = execute_javascript("return #{dom_element_by_xpath(xpath)}.value") if text.empty?
      text
    end

    # Calculate object size using Javascript
    # @param xpath [Sting] xpath of object
    # @return [Dimensions] size of element
    def element_size_by_js(xpath)
      width = execute_javascript("return #{dom_element_by_xpath(xpath)}.offsetWidth")
      height = execute_javascript("return #{dom_element_by_xpath(xpath)}.offsetHeight")
      Dimensions.new(width, height)
    end

    # Get object absolute postion from top left edge of screen
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

    def document_ready?
      execute_javascript('return document.readyState;') == 'complete'
    end

    # Get ComputedStyle property value
    # @param xpath [String] xpath of element
    # @param pseudo_element [String] pseudo element to compute
    # @param property [String] property to get
    # @return [String] value of property
    def computed_style(xpath, pseudo_element = 'null', property = nil)
      element_by_xpath = "document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext()"
      style = "window.getComputedStyle(#{element_by_xpath}, '#{pseudo_element}')"
      full_command = "#{style}.getPropertyValue('#{property}')"
      result = execute_javascript("return #{full_command}")
      result.delete('"')
    end

    # Remove element by its xpath
    # @param [String] xpath of element to remove
    # @return [String] result of javascript execution
    def remove_element(xpath)
      script = "element = #{dom_element_by_xpath(xpath)};"\
               'if (element !== null) '\
               '{element.parentNode.removeChild(element);};'
      execute_javascript(script)
    end
  end
end

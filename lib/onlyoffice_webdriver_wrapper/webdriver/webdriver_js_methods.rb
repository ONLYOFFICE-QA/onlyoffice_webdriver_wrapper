# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for webdriver for calling Javascript
  module WebdriverJsMethods
    def execute_javascript(script)
      result = @driver.execute_script(script)
      OnlyofficeLoggerHelper.log("Executed js: `#{script}` with result: `#{result}`")
      result
    rescue Exception => e
      webdriver_error("Exception #{e} in execute_javascript: #{script}")
    end

    # @return [String] string to select by xpath
    def jquery_selector_by_xpath(xpath)
      "$(document.evaluate('#{xpath}', document, null, XPathResult.ANY_TYPE, null).iterateNext())"
    end

    def type_to_locator_by_javascript(xpath_name, text)
      escaped_text = text.gsub('\\', '\\\\\\\\').gsub('"', '\\"').gsub("\n", '\\n')
      execute_javascript("document.evaluate('#{xpath_name}', document, null, XPathResult.ANY_TYPE, null).iterateNext().value=\"#{escaped_text}\";")
    end

    def get_text_by_js(xpath)
      execute_javascript("return document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext().textContent")
    end

    # Calculate object size using Javascript
    # @param xpath [Sting] xpath of object
    # @return [Dimensions] size of element
    def element_size_by_js(xpath)
      width = execute_javascript("return document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext().offsetWidth")
      height = execute_javascript("return document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext().offsetHeight")
      Dimensions.new(width, height)
    end

    # Get object absolute postion from top left edge of screen
    # @param xpath [Sting] xpath of object
    # @return [CursorPoint] position of element
    def object_absolute_position(xpath)
      left = execute_javascript("return document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext().getBoundingClientRect().left")
      top = execute_javascript("return document.evaluate(\"#{xpath.tr('"', "'")}\",document, null, XPathResult.ANY_TYPE, null ).iterateNext().getBoundingClientRect().top")
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
  end
end

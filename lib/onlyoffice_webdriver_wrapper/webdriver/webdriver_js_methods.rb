module OnlyofficeWebdriverWrapper
  # Methods for webdriver for calling Javascript
  module WebdriverJsMethods
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

    # Checks for jQuery finished its job or not present
    def jquery_finished?
      jquery_inactive = execute_javascript('return !!window.jQuery && window.jQuery.active;').zero?
      no_jquery = execute_javascript('return !!window.jQuery') == false
      jquery_inactive || no_jquery
    end
  end
end

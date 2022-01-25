# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Method to different wait_until methods
  module WaitUntilMethods
    # @return [Integer] default timeout for wait element
    TIMEOUT_WAIT_ELEMENT = 15

    # Wait until something happens
    # @param [String] timeout How much to wait
    # @param [String] message which message show if something happens
    # @param [Boolean] wait_js should we wait for JavaScript actions
    # @return [void]
    def wait_until(timeout = ::PageObject.default_page_wait, message = nil, wait_js: true, &block)
      tries ||= 3
      wait = Object::Selenium::WebDriver::Wait.new(timeout: timeout, message: message)
      wait.until(&block)
      if wait_js
        wait.until { document_ready? }
        wait.until { jquery_finished? }
      end
    rescue Selenium::WebDriver::Error::TimeoutError
      webdriver_error("Wait until timeout: #{timeout} seconds in")
    rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError => e
      webdriver_error(e.class, "JS Alert Happened: #{e}")
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      OnlyofficeLoggerHelper.log("Wait until: rescuing from Stale Element error, #{tries} attempts remaining")
      retry unless (tries -= 1).zero?
      webdriver_error('Wait until: rescuing from Stale Element error failed after 3 tries')
    end

    # Wait until element is visible
    # @param [String] xpath_name to find object
    # @param [Integer] timeout How much to wait
    # @raise [StandardError] error if element not found for timeout
    # @return [void]
    def wait_until_element_visible(xpath_name, timeout = 15)
      wait_until_element_present(xpath_name)
      time = 0
      while !element_visible?(xpath_name) && time < timeout
        sleep(1)
        time += 1
      end
      return unless time >= timeout

      webdriver_error("Element #{xpath_name} not visible for #{timeout} seconds")
    end

    # Wait until element present and visible
    # @param [String] xpath_name xpath of element
    # @param [Integer] period_of_wait how much time sleep each iteration of wait
    # @param [Integer] critical_time maximum time for wait for element
    # @return [nil]
    def wait_element(xpath_name, period_of_wait = 1, critical_time = 3)
      wait_until_element_present(xpath_name)
      time = 0
      until element_visible?(xpath_name)
        sleep(period_of_wait)
        time += 1
        return if time == critical_time
      end
    end

    # Wait until some element present
    # If timeout exceeded - raise an error
    # @param xpath_name [String] xpath of element
    # @param timeout [Integer] timeout to wait
    # @return [Void]
    def wait_until_element_present(xpath_name, timeout: TIMEOUT_WAIT_ELEMENT)
      wait = Selenium::WebDriver::Wait.new(timeout: timeout) # seconds
      begin
        wait.until { get_element(xpath_name) }
      rescue Selenium::WebDriver::Error::TimeoutError => e
        timeout_message = "wait_until_element_present(#{xpath_name}) "\
                          'Selenium::WebDriver::Error::TimeoutError: '\
                          "timed out after #{timeout} seconds"
        webdriver_error(e.class, timeout_message)
      end
    end

    # Wait until some element disappear
    # If timeout exceeded - raise an error
    # @param xpath_name [String] xpath of element
    # @param timeout [Integer] timeout to wait
    # @return [Void]
    def wait_until_element_disappear(xpath_name, timeout: TIMEOUT_WAIT_ELEMENT)
      wait = Selenium::WebDriver::Wait.new(timeout: timeout) # seconds
      begin
        wait.until { get_element(xpath_name) ? false : true }
      rescue Selenium::WebDriver::Error::TimeoutError => e
        timeout_message = "wait_until_element_present(#{xpath_name}) "\
                          'Selenium::WebDriver::Error::TimeoutError: '\
                          "timed out after #{timeout} seconds"
        webdriver_error(e.class, timeout_message)
      end
    end
  end
end
